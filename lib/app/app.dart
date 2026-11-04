
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/settings/settings_provider.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/auth_gate.dart';
import '../features/setlists/providers/shared_setlist_link_provider.dart';
import '../features/setlists/services/shared_setlist_link_handler.dart';

class MusicScrollApp extends ConsumerStatefulWidget {
  const MusicScrollApp({super.key});

  @override
  ConsumerState<MusicScrollApp> createState() => _MusicScrollAppState();
}

class _MusicScrollAppState extends ConsumerState<MusicScrollApp> {
  @override
  void initState() {
    super.initState();

    SharedSetlistLinkHandler.instance.start(
      onSharedSetlist: (token) {
        ref.read(sharedSetlistLinkProvider.notifier).state = token;
      },
    );
  }

  @override
  void dispose() {
    SharedSetlistLinkHandler.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'MusicScroll',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      home: const AuthGate(),
    );
  }
}
