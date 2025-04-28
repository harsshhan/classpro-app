import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic> _userData = {};
  Map<String, dynamic> _marksData = {};
  Map<String, dynamic> _attendanceData = {};
  Map<String, dynamic> _timetableData = {};
  bool _isLoading = true;

  Map<String, dynamic> get userData => _userData;
  Map<String, dynamic> get marksData => _marksData;
  Map<String, dynamic> get attendanceData => _attendanceData;
  List<dynamic> get attendanceList => _attendanceData['attendance'] ?? [];
  Map<String, dynamic> get timetableData => _timetableData;
  Map<String, dynamic> _calendarData = {};
  Map<String, dynamic> get calendarData => _calendarData;
  String get todayDayOrder => _calendarData['today']?['dayOrder'] ?? '';
  String get tomorrowDayOrder => _calendarData['tomorrow']?['dayOrder'] ?? '';
  bool get isLoading => _isLoading;

  void setUserData(Map<String, dynamic> data) {
    _userData = data;
    notifyListeners();
  }

  void setMarksData(Map<String, dynamic> data) {
    _marksData = data;
    notifyListeners();
  }

  void setAttendanceData(Map<String, dynamic> data) {
    _attendanceData = data;
    notifyListeners();
  }

  void setTimetableData(Map<String, dynamic> data) {
    _timetableData = data;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setCalendarData(Map<String, dynamic> data) {
    _calendarData = data;
    notifyListeners();
  }
}
