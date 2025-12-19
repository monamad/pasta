// lib/core/helper/functions.dart

/// Formats a [DateTime] into a 12-hour time string (no seconds).
/// Example: `02:05 PM`
String formatTime12h(DateTime dateTime) {
  final hour24 = dateTime.hour;
  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
  final period = hour24 >= 12 ? 'PM' : 'AM';

  String two(int v) => v.toString().padLeft(2, '0');

  return '${two(hour12)}:${two(dateTime.minute)} $period';
}

String formatTime12hFromHours(int hour24) {
  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
  final period = hour24 >= 12 ? 'PM' : 'AM';

  String two(int v) => v.toString().padLeft(2, '0');

  return '${two(hour12)}:00 $period';
}

String formatDateTime(DateTime dt) {
  String time = formatTime12h(dt);
  final d = dt.day.toString().padLeft(2, '0');
  final mo = dt.month.toString().padLeft(2, '0');
  return '$time  $d/$mo/${dt.year}';
}
