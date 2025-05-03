import 'package:classpro/provider/user_provider.dart';
import 'package:classpro/screens/home.dart';
import 'package:classpro/screens/loading_screen.dart';
import 'package:classpro/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import 'screens/connectionScreen.dart';
import 'screens/gradex.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Geist',
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Geist'),
      ),
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
      routes: {
        '/login': (context) => Login(),
        '/gradex': (context) => GradexPage(),
        '/home': (context) => Home(),
      },
    );
  }
}



