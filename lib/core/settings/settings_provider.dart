import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/storage_service.dart';
import 'app_settings.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(StorageService.loadSettings());

  void _save() {
    StorageService.saveSettings(state);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _save();
  }

  void setKeepScreenAwake(bool value) {
    state = state.copyWith(keepScreenAwake: value);
    _save();
  }

  void setScrollSpeed(double value) {
    state = state.copyWith(scrollSpeed: value);
    _save();
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);