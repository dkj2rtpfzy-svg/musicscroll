
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings/settings_provider.dart';
import '../../core/service/backup_export_service.dart';
import '../../core/service/auth/auth_service.dart';


class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _signOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text(
          'Votre compte sera déconnecté de MusicScroll. '
          'Vos chansons et vos setlists enregistrées sur cet appareil '
          'ne seront pas supprimées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );

    if (shouldSignOut != true || !context.mounted) return;

    try {
      await AuthService.signOut();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous êtes déconnecté de MusicScroll.'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la déconnexion : $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Réglages")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            title: "Apparence",
            icon: Icons.palette_outlined,
            child: RadioGroup<ThemeMode>(
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  notifier.setThemeMode(value);
                }
              },
              child: const Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text("Automatique"),
                    value: ThemeMode.system,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text("Clair"),
                    value: ThemeMode.light,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text("Sombre"),
                    value: ThemeMode.dark,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: "Concert",
            icon: Icons.mic,
            child: SwitchListTile(
              title: const Text("Garder l'écran allumé"),
              value: settings.keepScreenAwake,
              onChanged: notifier.setKeepScreenAwake,
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: "Défilement",
            icon: Icons.swipe,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Vitesse par défaut"),
                Slider(
                  min: 10,
                  max: 100,
                  divisions: 9,
                  value: settings.scrollSpeed,
                  label: settings.scrollSpeed.round().toString(),
                  onChanged: notifier.setScrollSpeed,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: "Sauvegarde",
            icon: Icons.backup_outlined,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.file_upload_outlined),
              title: const Text("Sauvegarder ma bibliothèque"),
              subtitle: const Text(
                "Exporter les chansons, paroles, accords, favoris et setlists",
              ),
              onTap: () async {
                try {
                  await BackupExportService.exportBackup();

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Fenêtre de partage ouverte. "
                        "Choisis où enregistrer la sauvegarde.",
                      ),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erreur lors de la sauvegarde : $e"),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: "Compte",
            icon: Icons.account_circle_outlined,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Se déconnecter"),
              subtitle: const Text(
                "Déconnecter votre compte sans supprimer votre bibliothèque",
              ),
              onTap: () => _signOut(context),
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: "À propos",
            icon: Icons.info_outline,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MusicScroll",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text("Version 1.0"),
                Text("© ALFAGA"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}
