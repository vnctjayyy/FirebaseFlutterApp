import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/auth_screen.dart'; // ✅ Import your AuthScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Flutter App',
      home: AuthScreen(),
    );
  }
}
