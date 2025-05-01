import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../services/api_service.dart';


class AppInitializer {
  static Future<void> initialize(
    BuildContext context, {
    required VoidCallback navigateToLogin,
    VoidCallback? navigateToHome,
    bool showSnackBarOnError = true,
  }) async {
    try {
      final token = await secureStorage.read(key: 'X-CSRF-TOKEN');
      if (token == null || token.isEmpty) {
        navigateToLogin();
        return;
      }

      final api = await ApiService.create();

      final userData = await api.validateToken();
      final marks = await api.getMarks();
      final attendance = await api.getAttendance();
      final timetable = await api.getTimetable();
      final calendar = await api.getCalendar();
      final courses = await api.getCourses();

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserData(userData);
      userProvider.setMarksData(marks);
      userProvider.setAttendanceData(attendance);
      userProvider.setTimetableData(timetable);
      userProvider.setCalendarData(calendar);
      userProvider.setCourseData(courses);
      userProvider.setLoading(false);

      navigateToHome?.call(); 
    } catch (e) {
      if (showSnackBarOnError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing app data: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      navigateToLogin();
    }
  }
}