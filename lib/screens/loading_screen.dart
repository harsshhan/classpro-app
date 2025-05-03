import 'package:classpro/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../services/initializer.dart';
import 'connectionScreen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curvedAnimation;

  bool? _isConnected;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _checkInternetAndInitialize();
  }

  Future<void> _checkInternetAndInitialize() async {
    final bool result = await NetworkUtils.hasInternetConnection();
    if (!mounted) return;

    if (!result) {
      setState(() {
        _isConnected = false;
      });
    } else {
      setState(() {
        _isConnected = true;
      });

      AppInitializer.initialize(
        context,
        navigateToLogin: _navigateToLogin,
        navigateToHome: _navigateToHome,
        showSnackBarOnError: true,
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected == false) {
      return NoInternetScreen(onRetry: _checkInternetAndInitialize);
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 29, 33, 1),
      body: Center(
        child: AnimatedBuilder(
          animation: _curvedAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _curvedAnimation.value * 2 * 3.14159,
              child: SizedBox(
                height: 96,
                width: 48,
                child: Image.asset(
                  'assets/icons/loading_icon.png',
                  color: const Color.fromRGBO(178, 178, 207, 1),
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