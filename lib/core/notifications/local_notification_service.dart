import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:pasta/core/extension/context_extention.dart';
import 'package:pasta/core/routing/routes.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract class ILocalNotificationService {
  Future<void> init();

  Future<void> scheduleEndBookingNotification({
    required DateTime endTime,
    required int notificationId,
    required String tableName,
    required double durationHours,
    required double totalPrice,
  });
  Future<void> showSessionEnded({
    required int notificationId,
    required String tableName,
    required double durationInHours,
    required double totalPrice,
  });
  Future<void> cancelBookingNotification(int notificationId);
}

class LocalNotificationService implements ILocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationService(this._plugin);

  static const String _channelId = 'session_events';
  static const String _channelName = 'Session events';
  static const String _channelDescription = 'Notifications for session updates';
  static const String _androidSmallIcon = '@mipmap/ic_launcher';

  static const int _maxNavRetries = 15;
  static const Duration _navRetryDelay = Duration(milliseconds: 250);
  int? _pendingHighlightSessionId;
  bool _navigationInProgress = false;

  @override
  Future<void> init() async {
    tz.initializeTimeZones();
    final TimezoneInfo currentTimeZone =
        await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
    const androidSettings = AndroidInitializationSettings(_androidSmallIcon);
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationTap(details.payload);
      },
    );

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    final launchedFromNotification =
        launchDetails?.didNotificationLaunchApp ?? false;
    if (launchedFromNotification) {
      _handleNotificationTap(launchDetails?.notificationResponse?.payload);
    }

    if (!kIsWeb) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.requestNotificationsPermission();

      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestExactAlarmsPermission();
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      await ios?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  @override
  Future<void> cancelBookingNotification(int notificationId) async {
    await _plugin.cancel(notificationId);
  }

  @override
  Future<void> scheduleEndBookingNotification({
    required DateTime endTime,
    required int notificationId,
    required String tableName,
    required double durationHours,
    required double totalPrice,
  }) async {
    await _plugin.zonedSchedule(
      notificationId,
      'Session ended',
      '$tableName • Duration: ${durationHours.toStringAsFixed(2)} hours\nTotal: ${totalPrice.toStringAsFixed(2)}',
      tz.TZDateTime.from(endTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          icon: _androidSmallIcon,
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
      payload: notificationId.toString(),
    );
  }

  @override
  Future<void> showSessionEnded({
    required int notificationId,
    required String tableName,
    required double durationInHours,
    required double totalPrice,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      icon: _androidSmallIcon,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      notificationId,
      'Session ended',
      '$tableName • Duration: ${durationInHours.toStringAsFixed(2)} hours\nTotal: ${totalPrice.toStringAsFixed(2)}',
      details,
      payload: notificationId.toString(),
    );
  }

  void _handleNotificationTap(String? payload) {
    final highlightId = int.tryParse(payload ?? '');
    if (highlightId == null) {
      _navigateToNotifications(null);
      return;
    }

    _navigateToNotifications(highlightId);
  }

  void _navigateToNotifications(int? highlightSessionId) {
    _pendingHighlightSessionId = highlightSessionId;
    if (_navigationInProgress) return;
    _navigationInProgress = true;
    _attemptNavigation(0);
  }

  void _attemptNavigation(int attempt) {
    final navigator = NavigationService.navigatorKey.currentState;
    if (navigator != null) {
      final highlightId = _pendingHighlightSessionId;
      _pendingHighlightSessionId = null;
      _navigationInProgress = false;
      navigator.pushNamed(Routes.notifications, arguments: highlightId);
      return;
    }

    if (attempt >= _maxNavRetries) {
      _navigationInProgress = false;
      return;
    }

    Future.delayed(_navRetryDelay, () => _attemptNavigation(attempt + 1));
  }
}
