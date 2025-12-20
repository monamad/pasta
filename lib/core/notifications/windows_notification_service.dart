import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:pasta/core/extension/context_extention.dart';
import 'package:pasta/core/notifications/local_notification_service.dart';
import 'package:pasta/core/routing/routes.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class WindowsNotificationService implements ILocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  WindowsNotificationService(this._plugin);

  static const String _windowsAppName = 'pasta';
  static const String _windowsAppUserModelId = 'com.example.pasta';
  // Stable GUID used by Windows toast notifications.
  static const String _windowsGuid = 'b6f3f3f7-2d55-4c1e-bb12-6e8a24ad0fdd';

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

    const windowsSettings = WindowsInitializationSettings(
      appName: _windowsAppName,
      appUserModelId: _windowsAppUserModelId,
      guid: _windowsGuid,
    );
    const settings = InitializationSettings(windows: windowsSettings);

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
      const NotificationDetails(windows: WindowsNotificationDetails()),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
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
    await _plugin.show(
      notificationId,
      'Session ended',
      '$tableName • Duration: ${durationInHours.toStringAsFixed(2)} hours\nTotal: ${totalPrice.toStringAsFixed(2)}',
      const NotificationDetails(windows: WindowsNotificationDetails()),
      payload: notificationId.toString(),
    );
  }

  @override
  Future<void> cancelBookingNotification(int notificationId) async {
    // Note: on Windows, cancel only works reliably when packaged as MSIX.
    await _plugin.cancel(notificationId);
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

class NoOpLocalNotificationService implements ILocalNotificationService {
  @override
  Future<void> init() async {}

  @override
  Future<void> scheduleEndBookingNotification({
    required DateTime endTime,
    required int notificationId,
    required String tableName,
    required double durationHours,
    required double totalPrice,
  }) async {}

  @override
  Future<void> showSessionEnded({
    required int notificationId,
    required String tableName,
    required double durationInHours,
    required double totalPrice,
  }) async {}

  @override
  Future<void> cancelBookingNotification(int notificationId) async {}
}
