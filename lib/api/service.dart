import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'X-CSRF-Token': csrfToken ?? '',
        },
      ),
    );

    return ApiService._(dio);
  }

  Future<Map<String, dynamic>> validateToken() async {
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
        return response.data;
      } else {
        throw Exception('Token invalid');
      }
    } catch (e) {
      throw Exception('Token validation failed');
    }
  }

  Future<Map<String, dynamic>> getAttendance() async {
    try {
      final response = await _dio.get('/attendance');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch attendance');
    }
  }

  Future<Map<String, dynamic>> getMarks() async {
    try {
      final response = await _dio.get('/marks');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch marks');
    }
  }

  Future<Map<String, dynamic>> getTimetable() async {
    try {
      final response = await _dio.get('/timetable');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch timetable');
    }
  }

  Future<Map<String, dynamic>> getCalendar() async {
    try {
      final response = await _dio.get('/calendar');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch timetable');
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
        await secureStorage.write(key: 'X-CSRF-TOKEN', value: cookies);
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'X-CSRF-TOKEN');
  }
}