import 'package:flutter/material.dart';

import '../../core/widgets/menu_card.dart';
import '../concert/concert_selector_screen.dart';
import '../favorites/favorites_screen.dart';
import '../library/library_screen.dart';
import '../setlists/screens/setlists_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MusicScroll"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.music_note,
              size: 90,
            ),

            const SizedBox(height: 16),

            const Center(
              child: Text(
                "MusicScroll",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                "Powered by ALFAGA",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 40),

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
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
