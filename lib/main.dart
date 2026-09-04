import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const ICYApp());
}

class ICYApp extends StatelessWidget {
  const ICYApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ICY Ceramic',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F4EE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC9A995),
        ),
        fontFamily: 'serif',
      ),
      home: const LoginScreen(),
    );
  }
}