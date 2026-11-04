
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/service/auth/auth_service.dart';
import '../home/home_screen.dart';
import '../setlists/providers/shared_setlist_link_provider.dart';
import '../setlists/services/shared_setlist_importer.dart';
import 'auth_screen.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _handlingToken = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(
      sharedSetlistLinkProvider,
      (previous, next) {
        if (next != null && AuthService.currentUser != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleSharedSetlist(next);
          });
        }
      },
    );

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

        final token = ref.watch(sharedSetlistLinkProvider);

        if (token != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleSharedSetlist(token);
          });
        }

        return const HomeScreen();
      },
    );
  }

  Future<void> _handleSharedSetlist(String token) async {
    if (!mounted || _handlingToken) return;

    final currentToken = ref.read(sharedSetlistLinkProvider);
    if (currentToken != token) return;

    if (AuthService.currentUser == null) return;

    _handlingToken = true;

    try {
      final shouldImport = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Setlist partagée'),
          content: const Text(
            'Une setlist vous a été partagée. '
            'Voulez-vous l’importer dans votre bibliothèque ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Plus tard'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Importer'),
            ),
          ],
        ),
      );

      if (!mounted) return;

      if (shouldImport == true) {
        final name = await SharedSetlistImporter.importSetlist(
          ref: ref,
          token: token,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              name == null
                  ? 'Cette setlist partagée est introuvable.'
                  : 'Setlist "$name" importée avec succès.',
            ),
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible d’importer la setlist : $error'),
        ),
      );
    } finally {
      if (mounted &&
          ref.read(sharedSetlistLinkProvider) == token) {
        ref.read(sharedSetlistLinkProvider.notifier).state = null;
      }

      _handlingToken = false;
    }
  }
}
