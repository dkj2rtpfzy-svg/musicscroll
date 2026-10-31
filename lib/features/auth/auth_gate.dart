
import 'package:flutter/material.dart';

import '../../core/service/auth/auth_service.dart';
import '../home/home_screen.dart';
import 'auth_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            AuthService.currentUser == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = snapshot.data?.session?.user ??
            AuthService.currentUser;

        if (user == null) {
          return const AuthScreen();
        }

        return const HomeScreen();
      },
    );
  }
}
