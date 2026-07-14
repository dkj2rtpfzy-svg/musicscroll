import 'package:flutter/material.dart';

import '../models/setlist.dart';

class SetlistDetailScreen extends StatelessWidget {
  final Setlist setlist;

  const SetlistDetailScreen({
    super.key,
    required this.setlist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(setlist.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Sprint suivant : Ajouter un morceau à la setlist
        },
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text(
          "Cette setlist ne contient encore aucun morceau.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}