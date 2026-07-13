import 'package:flutter/material.dart';
import 'features/library/library_screen.dart';


void main() {
  runApp(const MusicScrollApp());
}

class MusicScrollApp extends StatelessWidget {
  const MusicScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicScroll',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
  brightness: Brightness.dark,
  colorSchemeSeed: Colors.blue,
  useMaterial3: true,
),
home: const LibraryScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎵 MusicScroll'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            MenuCard(
              icon: Icons.library_music,
              title: 'Bibliothèque',
            ),
            MenuCard(
              icon: Icons.queue_music,
              title: 'Setlists',
            ),
            MenuCard(
              icon: Icons.mic,
              title: 'Mode Concert',
            ),
            MenuCard(
              icon: Icons.settings,
              title: 'Réglages',
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontSize: 22),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
