import 'package:flutter/material.dart';

import 'core/widgets/range_date_picker_custom.dart';


final _timeNow = DateTime.now();

extension AppCoordinator<T> on BuildContext{
  void pop() => Navigator.of(this).pop();
  void popUntil(String nRoute) =>
      Navigator.popUntil(this, ModalRoute.withName(nRoute));
  void popArgs(T? args) => Navigator.of(this).pop(args);

  void startSelectedBottomBarItem(int view) {}


  Future<DateTime?> pickDateTime() async {
    DateTime? date = (await pickDate(DatePickerMode.day));
    if (date == null) {
      return null;
    }
    TimeOfDay? time = await pickTime();
    if (time == null) {
      return null;
    }
    return date.copyWith(hour: time.hour, minute: time.minute);
  }

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: this,
        initialTime: TimeOfDay(
          hour: _timeNow.hour,
          minute: _timeNow.minute,
        ),
      );

  Future<DateTime?> pickDate(DatePickerMode mode) => showDatePicker(
        initialDatePickerMode: mode,
        context: this,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );


Future<List<DateTime>?> pickRangeDate(
    RangeDateController rangeDateController,
  ) async {
    final dates = await showDialog(
      context: this,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: RangeDatePicDialog(
          height: 450,
          rangeDateController: rangeDateController,
        ),
      ),
    );
    if (dates is List<DateTime>) {
      return dates;
    }
    return null;
  }

  Future<List<DateTime>?> pickWeekRange(
    RangeDateController rangeDateController,
  ) async {
    final dates = await showDialog(
      context: this,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: RangeDatePicDialog(
          height: 450,
          rangeDateController: rangeDateController,
          rangeDatePicType: RangeDatePicType.weekRange,
        ),
      ),
    );
    if (dates is List<DateTime>) {
      return dates;
    }
    return null;
  }

  Future<T?> openListPageWithRoute(String route) {
    // return Navigator.push(this, route).;
    return Navigator.of(this).pushNamed(route);
  }

  Future<T?> pushAndRemoveAll(String route) {
    return Navigator.of(this).pushNamedAndRemoveUntil(route, (route) => false);
  }

  Future<T?> openPageWithRouteAndParams(String route, dynamic param) {
    return Navigator.of(this).pushNamed(route, arguments: param);
  }

  

}