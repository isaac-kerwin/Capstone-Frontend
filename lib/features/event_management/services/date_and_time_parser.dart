String formatDateAsWords(DateTime dateTime) {
  // 1. Day of week names
  final List<String> weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday',
  ];
  final String weekdayName = weekdays[dateTime.weekday - 1]; 

  final int day = dateTime.day;
  final String dayWithSuffix = _getOrdinalDay(day);


  final List<String> months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];
  final String monthName = months[dateTime.month - 1];

  final int year = dateTime.year;

  return '$weekdayName $dayWithSuffix $monthName $year';
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String formatDateRangeAsWords(DateTime start, DateTime end) {
  final startStr = formatDateAsWords(start);
  final endStr   = formatDateAsWords(end);

  if (_isSameDay(start, end)) {
    return startStr;
  } else {
    return '$startStr -\n$endStr';
  }
}


String _getOrdinalDay(int day) {
  if (day >= 11 && day <= 13) {
    return '${day}th';
  }
  switch (day % 10) {
    case 1:
      return '${day}st';
    case 2:
      return '${day}nd';
    case 3:
      return '${day}rd';
    default:
      return '${day}th';
  }
}

String formatTimeAmPm(DateTime dateTime) {
  final hour24 = dateTime.hour;
  final minute = dateTime.minute;

  final suffix = hour24 >= 12 ? 'pm' : 'am';

  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;

  final minuteStr = minute.toString().padLeft(2, '0');
  
  return '$hour12:$minuteStr$suffix';
}



