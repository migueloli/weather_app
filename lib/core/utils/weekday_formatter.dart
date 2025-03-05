import 'package:flutter/material.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';

abstract class WeekdayFormatter {
  const WeekdayFormatter._();

  static String getWeekdayAbreviation(BuildContext context, int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return AppLocalizations.of(context)!.dayMon;
      case DateTime.tuesday:
        return AppLocalizations.of(context)!.dayTue;
      case DateTime.wednesday:
        return AppLocalizations.of(context)!.dayWed;
      case DateTime.thursday:
        return AppLocalizations.of(context)!.dayThu;
      case DateTime.friday:
        return AppLocalizations.of(context)!.dayFri;
      case DateTime.saturday:
        return AppLocalizations.of(context)!.daySat;
      case DateTime.sunday:
        return AppLocalizations.of(context)!.daySun;
      default:
        return '';
    }
  }

  static String getWeekdayName(BuildContext context, int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return AppLocalizations.of(context)!.dayMonday;
      case DateTime.tuesday:
        return AppLocalizations.of(context)!.dayTuesday;
      case DateTime.wednesday:
        return AppLocalizations.of(context)!.dayWednesday;
      case DateTime.thursday:
        return AppLocalizations.of(context)!.dayThursday;
      case DateTime.friday:
        return AppLocalizations.of(context)!.dayFriday;
      case DateTime.saturday:
        return AppLocalizations.of(context)!.daySaturday;
      case DateTime.sunday:
        return AppLocalizations.of(context)!.daySunday;
      default:
        return '';
    }
  }
}
