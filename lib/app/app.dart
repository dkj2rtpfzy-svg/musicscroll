import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/settings/settings_provider.dart';
import '../core/theme/app_theme.dart';
import '../features/home/home_screen.dart';

class MusicScrollApp extends ConsumerWidget {
  const MusicScrollApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'MusicScroll',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,

      home: const HomeScreen(),
    );
  }
}