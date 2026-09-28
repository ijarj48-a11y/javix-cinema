import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const JavixCinemaApp());
}

class JavixCinemaApp extends StatelessWidget {
  const JavixCinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Javix Cinema',
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}
