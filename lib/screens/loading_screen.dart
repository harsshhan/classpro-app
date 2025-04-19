import 'package:classpro/api/service.dart';
import 'package:classpro/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

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
    _initAppData(context);
  }

  Future<void> _startHourglassAnimation() async {
    while (mounted) {
      await _controller.forward(from: 0.0);
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _initAppData(BuildContext context) async {
  try {
    final token = await secureStorage.read(key: 'X-CSRF-TOKEN');
    if (token == null || token.isEmpty) {
      _navigateToLogin();
      return;
    }

    final api = await ApiService.create();


    final userData = await api.validateToken();
    final marks = await api.getMarks();
    final attendance = await api.getAttendance();
    final timetable = await api.getTimetable();


    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUserData(userData);
    userProvider.setMarksData(marks);
    userProvider.setAttendanceData(attendance);
    userProvider.setTimetableData(timetable);

    userProvider.setLoading(false);

    _navigateToHome();
  } catch (e) {
    SnackBar(
      content: Text(
        'Error initializing app data: $e',
        style: const TextStyle(color: Colors.red),
      ),
      backgroundColor: Colors.black87,
    );
    _navigateToLogin();
  }
}

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/gradex');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 29, 33, 1),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 3.14159,
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