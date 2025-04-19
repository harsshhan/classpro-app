import 'package:classpro/api/service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  @override
  Widget build(BuildContext context) {
    

    return Container(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 410,
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
                      height: 100,
                    ),
                    const Text(
                      "University data, beautifully presented at your",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "fingertips",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: const BoxDecoration(
                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _userIdController,
                          decoration: const InputDecoration(
                              hintText: "User ID",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: const BoxDecoration(
                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        String userId = _userIdController.text.trim();
                        String password = _passwordController.text.trim();
                        if (userId.isNotEmpty && password.isNotEmpty) {
                          setState(() {
                            _isLoading = true;
                          });
                          bool isLoggedIn = await login(userId, password);
                          setState(() {
                            _isLoading = false; 
                          });

                          if (isLoggedIn) {
                            ApiService apiService = await ApiService.create();
                            await apiService.validateToken();

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
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(127, 127, 149, 1),
                            borderRadius: BorderRadius.circular(15)),
                        child:  Center(
                          child: _isLoading
                              ?  SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
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
