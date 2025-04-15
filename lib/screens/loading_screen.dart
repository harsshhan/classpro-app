import 'package:classpro/api/service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600), 
      vsync: this,
    );

    _startHourglassAnimation();

    _checkAuthToken(context);
  }

  Future<void> _startHourglassAnimation() async {
    while (mounted) {
      await _controller.forward(from: 0.0);
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _checkAuthToken(BuildContext context) async {
  String? csrfToken = await secureStorage.read(key: 'X-CSRF-TOKEN');

  if (csrfToken != null && csrfToken.isNotEmpty) {  
    try {
      await (await ApiService.create()).validateToken(context);
    } catch (e) {
      _navigateToLogin(context);
    }
  } else {
    _navigateToLogin(context);
  }
}

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 29, 33, 1), 
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 3.141592653589793, 
              child: SizedBox(
                height: 96,
                width: 48,
                child: Image.asset(
                  'assets/icons/loading_icon.png', color: Color.fromRGBO(178, 178, 207, 1),
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}