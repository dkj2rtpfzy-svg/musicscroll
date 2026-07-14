import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/setlist_provider.dart';

class SetlistsScreen extends ConsumerWidget {
  const SetlistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setlists = ref.watch(setlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Setlists"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final controller = TextEditingController();

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Nouvelle Setlist"),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Nom de la setlist",
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Annuler"),
                ),
                FilledButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      ref
                          .read(setlistProvider.notifier)
                          .addSetlist(controller.text.trim());
                    }

                    Navigator.pop(context);
                  },
                  child: const Text("Créer"),
                ),
              ],
            ),
          );
        },
      ),
      body: setlists.isEmpty
          ? const Center(
              child: Text(
                "Aucune setlist.\nAppuyez sur + pour commencer.",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: setlists.length,
              itemBuilder: (context, index) {
                final setlist = setlists[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.queue_music),
                    title: Text(setlist.name),
                    subtitle: Text(
                      "${setlist.songIndexes.length} morceau(x)",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref
                            .read(setlistProvider.notifier)
                            .removeSetlist(setlist.id);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}