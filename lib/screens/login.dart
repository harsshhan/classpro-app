import 'package:classpro/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/initializer.dart';
import '../styles.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<bool> login(String account, String password) async {
    try {
      Dio dio = Dio();
      final response = await dio.post(
        '${dotenv.env['API_URL']!}/login',
        data: {
          "account": account,
          "password": password,
        },
      );

      if (response.statusCode == 200 &&
          response.data['authenticated'] == true) {
        String? token = response.data['cookies'];
        if (token!.isNotEmpty) {
          await secureStorage.write(key: 'X-CSRF-TOKEN', value: token);
          return true;
        } else {
          _showSnackbar('No cookies received in headers.');
        }
      } else {
        _showSnackbar('Login failed: ');
      }
    } catch (e) {
      _showSnackbar('Error logging in');
    }
    return false;
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/gradex');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 380,
              width: 408,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(50)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/logo.png',
                      width: 150,
                      height: 40,
                      color: AppColors.accentColor,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "University data, beautifully presented at your",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          decoration: TextDecoration.none),
                    ),
                    const Text(
                      "fingertips",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      height: 50,
                      width: 250,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: const BoxDecoration(
                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15)),
                      ),
                      child: Center(
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _userIdController,
                          decoration: const InputDecoration(
                              hintText: "User ID",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Geist"),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      height: 50,
                      width: 250,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: const BoxDecoration(
                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: TextField(
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 25),
                    GestureDetector(
                      onTap: () async {
                        String userId = _userIdController.text.trim();
                        String password = _passwordController.text.trim();
                        if (userId.isNotEmpty && password.isNotEmpty) {
                          setState(() {
                            _isLoading = true;
                          });
                          bool isLoggedIn = await login(userId, password);

                          if (isLoggedIn) {
                            ApiService apiService = await ApiService.create();
                            final user = await apiService.validateToken();
                            if (user != null) {
                              // if (!mounted) return;
                              // setState(() {
                              //   _isLoading = false;
                              // });
                              AppInitializer.initialize(
                                context,
                                navigateToLogin: _navigateToLogin,
                                navigateToHome: _navigateToHome,
                                showSnackBarOnError: true,
                              );
                            }
                          } else {
                            _showSnackbar(
                                'Login failed. Please check your credentials.');
                          }
                        } else {
                          _showSnackbar('Please fill in all fields.');
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 180,
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                            color: AppColors.accentColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
