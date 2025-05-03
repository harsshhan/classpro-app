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

      // Fire all API calls in parallel
      final results = await Future.wait([
        api.validateToken(),
        api.getMarks(),
        api.getAttendance(),
        api.getTimetable(),
        api.getCalendar(),
        api.getCourses(),
      ]);

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      userProvider.setUserData(results[0]);
      userProvider.setMarksData(results[1]);
      userProvider.setAttendanceData(results[2]);
      userProvider.setTimetableData(results[3]);
      userProvider.setCalendarData(results[4]);
      userProvider.setCourseData(results[5]);
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
