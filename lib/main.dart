import 'package:classpro/screens/loading_screen.dart';
import 'package:classpro/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
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
      routes: {
        '/': (context) => LoadingScreen(),
        '/login': (context) => Login(),
        // '/home': (context) =>  Home(),
      },
      initialRoute: '/',
    );
  }
}
