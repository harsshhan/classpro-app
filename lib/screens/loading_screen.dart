import 'package:classpro/screens/home.dart';
import 'package:classpro/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final Dio dio = Dio(); 

  @override
  void initState() {
    super.initState();
    _checkAuthToken(); 
  }

  Future<void> _checkAuthToken() async {
    String? csrfToken = await secureStorage.read(key: 'X-CSRF-TOKEN');

    if (csrfToken != null && csrfToken.isNotEmpty) {
      bool isValid = await _validateToken(csrfToken);

      if (isValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  Home()),
        );
      } else {
        _navigateToLogin();
      }
    } else {
      _navigateToLogin();
    }
  }

  Future<bool> _validateToken(String csrfToken) async {
    try {
      final response = await dio.get(
        dotenv.env['API_URL']! + '/user', 
        options: Options(
          headers: {
            'X-CSRF-Token': csrfToken,
          },
        ),
      );

      if (response.statusCode == 401 || response.statusCode == 500) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print('Error validating token: $e');
      return false;
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(), 
      ),
    );
  }
}