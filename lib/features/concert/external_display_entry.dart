import 'package:flutter/material.dart';
import 'package:external_display/transfer_parameters.dart';
import '../../shared/widgets/chord_pro_viewer.dart';

@pragma('vm:entry-point')
void externalDisplayMain() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExternalDisplayEntry(),
    ),
  );
}

class ExternalDisplayEntry extends StatefulWidget {
  const ExternalDisplayEntry({super.key});

  @override
  State<ExternalDisplayEntry> createState() => _ExternalDisplayEntryState();
}

class _ExternalDisplayEntryState extends State<ExternalDisplayEntry> {
  String _lyrics = '';

  void _receiveParameters({required String action, dynamic value}) {
    if (action == 'lyrics' && value is String && mounted) {
      setState(() {
        _lyrics = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    transferParameters.addListener(_receiveParameters);
  }

  @override
  void dispose() {
    transferParameters.removeListener(_receiveParameters);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _lyrics.isEmpty
            ? const Center(
                child: Text(
                  'En attente des paroles…',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 32,
                ),
                child: ChordProViewer(
                  lyrics: _lyrics,
                  fontSize: 36,
                ),
              ),
      ),
    );
  }
}