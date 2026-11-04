import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

class SharedSetlistLinkHandler {
  SharedSetlistLinkHandler._();

  static final SharedSetlistLinkHandler instance =
      SharedSetlistLinkHandler._();

  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _subscription;

  void start({
    required void Function(String token) onSharedSetlist,
  }) {
    _subscription ??= _appLinks.uriLinkStream.listen(
      (uri) {
        final token = _extractToken(uri);

        if (token != null) {
          onSharedSetlist(token);
        }
      },
      onError: (Object error) {
        debugPrint('Erreur de réception du lien MusicScroll : $error');
      },
    );

    _appLinks.getInitialLink().then((uri) {
      if (uri == null) return;

      final token = _extractToken(uri);

      if (token != null) {
        onSharedSetlist(token);
      }
    }).catchError((Object error) {
      debugPrint('Erreur de lecture du lien initial MusicScroll : $error');
    });
  }

  String? _extractToken(Uri uri) {
    if (uri.scheme != 'musicscroll') return null;
    if (uri.host != 'shared-setlist') return null;
    if (uri.pathSegments.length != 1) return null;

    final token = uri.pathSegments.first.trim();

    if (token.isEmpty) return null;

    return token;
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}