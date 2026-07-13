import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MusicScroll"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.music_note,
                size: 100,
              ),

              const SizedBox(height: 24),

              const Text(
                "Bienvenue sur MusicScroll",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                "L'application pensée pour les musiciens.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade400,
                ),
              ),

              const SizedBox(height: 40),

              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.library_music),
                label: const Text("Accéder à la bibliothèque"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}