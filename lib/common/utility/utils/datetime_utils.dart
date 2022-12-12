import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';

class DateTimeUtils {
  static String formatDateTime(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();

    final int year = localDateTime.year;
    final int month = localDateTime.month;
    final int day = localDateTime.day;
    final int hour = localDateTime.hour;
    final int minute = localDateTime.minute;

    return tra(LocaleKeys.txt_dateTimeWA, namedArgs: {
      'year': year.toString(),
      'month': month.toString(),
      'day': day.toString(),
      'hour': hour.toString().padLeft(2, '0'),
      'minute': minute.toString().padLeft(2, '0'),
    });
  }

  static String formatDateOnly(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();

    final int year = localDateTime.year;
    final int month = localDateTime.month;
    final int day = localDateTime.day;

    return tra(LocaleKeys.txt_dateOnlyWA, namedArgs: {
      'year': year.toString(),
      'month': month.toString(),
      'day': day.toString(),
    });
  }

  static String formatTimeOnly(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();

    final int hour = localDateTime.hour;
    final int minute = localDateTime.minute;

    return tra(LocaleKeys.txt_timeOnlyWA, namedArgs: {
      'hour': hour.toString().padLeft(2, '0'),
      'minute': minute.toString().padLeft(2, '0'),
    });
  }

  static String formatDateTimeShort(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    final dateTimeNow = DateTime.now();
    final int year = localDateTime.year;
    final int month = localDateTime.month;
    final int day = localDateTime.day;
    final int hour = localDateTime.hour;
    final int minute = localDateTime.minute;
    if (dateTimeNow.day == localDateTime.day &&
        dateTimeNow.month == localDateTime.month &&
        dateTimeNow.year == localDateTime.year) {
      return tra(LocaleKeys.txt_timeOnlyWA, namedArgs: {
        'hour': hour.toString().padLeft(2, '0'),
        'minute': minute.toString().padLeft(2, '0'),
      });
    } else {
      return tra(LocaleKeys.txt_dateOnlyWA, namedArgs: {
        'year': year.toString(),
        'month': month.toString(),
        'day': day.toString(),
      });
    }
  }
}
