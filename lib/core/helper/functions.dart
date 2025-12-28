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

DateTime nowDateTime() {
  return DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
    DateTime.now().second,
  );
}

double diffInHours(DateTime start, DateTime end) =>
    start.difference(end).inMinutes / 60;

bool isTimeEqualByMinute(DateTime a, DateTime b) {
  return a.difference(b).inMinutes == 0;
}

String formatTime(DateTime dateTime) {
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final month = months[dateTime.month - 1];
  final day = dateTime.day;
  final year = dateTime.year;

  int hour = dateTime.hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = hour >= 12 ? 'PM' : 'AM';

  if (hour > 12) {
    hour -= 12;
  } else if (hour == 0) {
    hour = 12;
  }

  return '$month $day, $year at $hour:$minute $period';
}

DateTime removeMilliseconds(DateTime dateTime) {
  return DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
    dateTime.second,
  );
}

int binarySearch<T>(List<T> sortedList, int target) {
  int left = 0;
  int right = sortedList.length - 1;
  while (left <= right) {
    int mid = left + ((right - left) >> 1);
    int midValue = (sortedList[mid] as dynamic).session.id;

    if (midValue == target) {
      return mid;
    } else if (midValue < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }

  return -1;
}
