import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/setlist_provider.dart';

class SelectSetlistDialog extends ConsumerWidget {
  final String songId;

  const SelectSetlistDialog({
    super.key,
    required this.songId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setlists = ref.watch(setlistProvider);

    if (setlists.isEmpty) {
      return AlertDialog(
        title: const Text("Aucune Setlist"),
        content: const Text(
          "Créez d'abord une Setlist avant d'ajouter un morceau.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      );
    }

    return AlertDialog(
      title: const Text("Choisir une Setlist"),
      content: SizedBox(
        width: 350,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: setlists.length,
          itemBuilder: (_, index) {
            final setlist = setlists[index];

            return ListTile(
              leading: const Icon(Icons.queue_music),
              title: Text(setlist.name),
              subtitle: Text(
                "${setlist.songIds.length} morceau(x)",
              ),
              onTap: () {
                ref.read(setlistProvider.notifier).addSong(
                      setlist.id,
                      songId,
                    );

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Ajouté à « ${setlist.name} »",
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}