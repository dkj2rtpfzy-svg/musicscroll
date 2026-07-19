import 'package:flutter/material.dart';

class AppSettings {
  final ThemeMode themeMode;
  final bool keepScreenAwake;
  final double scrollSpeed;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.keepScreenAwake = true,
    this.scrollSpeed = 50,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? keepScreenAwake,
    double? scrollSpeed,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
      scrollSpeed: scrollSpeed ?? this.scrollSpeed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.name,
      'keepScreenAwake': keepScreenAwake,
      'scrollSpeed': scrollSpeed,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.name == map['themeMode'],
        orElse: () => ThemeMode.system,
      ),
      keepScreenAwake: map['keepScreenAwake'] ?? true,
      scrollSpeed: (map['scrollSpeed'] ?? 50).toDouble(),
    );
  }

  static const defaults = AppSettings();
}