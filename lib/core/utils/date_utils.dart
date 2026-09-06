/// Date utility functions for the Hafiz app.
///
/// Supports both Hijri and Gregorian calendar display.
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

/// Format date as readable string.
String formatDate(DateTime date, {String locale = 'ar'}) {
  return DateFormat.yMMMMd(locale).format(date);
}

/// Format date as short string (e.g., "Sep 6, 2026").
String formatDateShort(DateTime date, {String locale = 'ar'}) {
  return DateFormat.yMMMd(locale).format(date);
}

/// Format time (e.g., "09:00 AM").
String formatTime(DateTime date, {String locale = 'ar'}) {
  return DateFormat.jm(locale).format(date);
}

/// Format date and time.
String formatDateTime(DateTime date, {String locale = 'ar'}) {
  return DateFormat.yMMMd(locale).add_jm().format(date);
}

/// Get Hijri date string.
String getHijriDate(DateTime date) {
  final hijri = HijriCalendar.fromDate(date);
  return hijri.toFormatDDMMMMYYYY();
}

/// Get day name in Arabic.
String getDayNameArabic(DateTime date) {
  const days = [
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];
  return days[date.weekday - 1];
}

/// Get month name in Arabic.
String getMonthNameArabic(int month) {
  const months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  return months[month - 1];
}

/// Check if date is today.
bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year && date.month == now.month && date.day == now.day;
}

/// Check if date is yesterday.
bool isYesterday(DateTime date) {
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  return date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day;
}

/// Get relative time string (e.g., "2 hours ago", "yesterday").
String getRelativeTime(DateTime date, {String locale = 'ar'}) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (isToday(date)) {
    return formatTime(date, locale: locale);
  } else if (isYesterday(date)) {
    return locale == 'ar' ? 'أمس' : 'Yesterday';
  } else if (difference.inDays < 7) {
    return getDayNameArabic(date);
  } else {
    return formatDateShort(date, locale: locale);
  }
}
