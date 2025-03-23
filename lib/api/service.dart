import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/home.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class ApiService {
  final String apiUrl = dotenv.env['API_URL']!;

  late final Dio _dio;

  ApiService._(this._dio);

  static Future<ApiService> create() async {
    String? csrfToken = await secureStorage.read(key: 'X-CSRF-TOKEN');

    Dio dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_URL']!,
        headers: {
          'X-CSRF-Token': csrfToken ?? '',
        },
      ),
    );

    return ApiService._(dio);
  }

  Future<Map<String, dynamic>> getAttendance() async {
    try {
      final response = await _dio.get('/attendance');
      return response.data;
    } catch (e) {
      print('Error fetching attendance: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getMarks() async {
    try {
      final response = await _dio.get('/marks');
      return response.data;
    } catch (e) {
      print('Error fetching marks: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getTimetable() async {
    try {
      final response = await _dio.get('/timetable');
      return response.data;
    } catch (e) {
      print('Error fetching timetable: $e');
      return {};
    }
  }

  Future<void> login(String account, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'account': account,
          'password': password,
        },
      );

      if (response.statusCode == 201 &&
          response.data['authenticated'] == true) {
        String? cookies = response.data['cookies'];
        if (cookies != null) {
          await secureStorage.write(key: 'X-CSRF-TOKEN', value: cookies);
          print('CSRF token stored securely.');
        } else {
          print('No CSRF token received.');
        }
      } else {
        print('Login failed: ${response.data['message']}');
      }
    } catch (e) {
      print('Error logging in: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    await secureStorage.delete(key: 'X-CSRF-TOKEN');
    Navigator.pushReplacementNamed(context, '/login');
  }


  Future<bool> validateToken(BuildContext context,) async {
  try {
    String? csrfToken = await secureStorage.read(key: 'X-CSRF-TOKEN');
    final response = await _dio.get(
      '/user',
      options: Options(
        headers: {
          'X-CSRF-Token': csrfToken,
        },
      ),
    );

    if (response.statusCode == 200 && response.data != null) {

      Map<String, dynamic> userData = response.data; 

      if (userData.isNotEmpty) {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Home(userDataList: userData), // ✅ Pass Map to Home
            ),
            (Route<dynamic> route) => false,
          );
        }
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
}
