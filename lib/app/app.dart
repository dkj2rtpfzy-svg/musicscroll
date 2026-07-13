import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/home/home_screen.dart';

class MusicScrollApp extends StatelessWidget {
  const MusicScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicScroll',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.darkTheme,

      home: const HomeScreen(),
    );
  }
}