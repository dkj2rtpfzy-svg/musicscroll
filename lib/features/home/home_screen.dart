import 'package:flutter/material.dart';

import '../../core/widgets/menu_card.dart';
import '../concert/concert_selector_screen.dart';
import '../favorites/favorites_screen.dart';
import '../library/library_screen.dart';
import '../setlists/screens/setlists_screen.dart';
import '../settings/settings_page.dart';
import '../tuner/presentation/tuner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("MusicScroll"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: isDark
                      ? const [
                          Color(0xFF2D2D2D),
                          Color(0xFF1A1A1A),
                        ]
                      : [
                          theme.colorScheme.primary.withValues(alpha: 0.12),
                          theme.colorScheme.primary.withValues(alpha: 0.04),
                        ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.music_note_rounded,
                    size: 54,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "MusicScroll",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Prêt à jouer ?\nRetrouvez votre bibliothèque et tous vos outils musicaux.",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Accès rapide",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            MenuCard(
              icon: Icons.library_music,
              title: "Bibliothèque",
              subtitle: "Tous vos morceaux",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LibraryScreen(),
                  ),
                );
              },
            ),
            MenuCard(
              icon: Icons.star,
              title: "Favoris",
              subtitle: "Vos morceaux préférés",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoritesScreen(),
                  ),
                );
              },
            ),
            MenuCard(
              icon: Icons.mic,
              title: "Mode Concert",
              subtitle: "Défilement automatique",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ConcertSelectorScreen(),
                  ),
                );
              },
            ),
            MenuCard(
              icon: Icons.tune,
              title: "Accordeur",
              subtitle: "Guitare • Basse • Ukulélé",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TunerScreen(),
                  ),
                );
              },
            ),
            MenuCard(
              icon: Icons.queue_music,
              title: "Setlists",
              subtitle: "Préparez vos concerts",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SetlistsScreen(),
                  ),
                );
              },
            ),
            MenuCard(
              icon: Icons.settings,
              title: "Réglages",
              subtitle: "Préférences de l'application",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}