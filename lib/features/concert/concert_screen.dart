import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:external_display/external_display.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../shared/models/song.dart';
import '../../shared/widgets/chord_pro_viewer.dart';

class ConcertScreen extends StatefulWidget {
  final Song song;

  const ConcertScreen({
    super.key,
    required this.song,
  });

  @override
  State<ConcertScreen> createState() => _ConcertScreenState();
}

class _ConcertScreenState extends State<ConcertScreen>
    with SingleTickerProviderStateMixin {
  bool _showControls = false;
  bool _isPlaying = false;
  double _lyricsFontSize = 28;

  final ScrollController _scrollController = ScrollController();

  late final Ticker _ticker;
  Duration? _lastElapsed;

  double _scrollSpeed = 50;

  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();

    WakelockPlus.enable();

    _ticker = createTicker((elapsed) {
      if (!_isPlaying) return;
      if (!_scrollController.hasClients) return;

      if (_lastElapsed == null) {
        _lastElapsed = elapsed;
        return;
      }

      final delta =
          (elapsed - _lastElapsed!).inMicroseconds / 1000000.0;

      _lastElapsed = elapsed;

      final nextOffset =
          _scrollController.offset + (_scrollSpeed * delta);

      if (nextOffset >= _scrollController.position.maxScrollExtent) {
        _ticker.stop();

        if (!mounted) return;

        setState(() {
          _isPlaying = false;
        });

        return;
      }

      _scrollController.jumpTo(nextOffset);
    });
  }

  void _showControlsTemporarily() {
    _controlsTimer?.cancel();

    setState(() {
      _showControls = true;
    });

    _controlsTimer = Timer(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;

        setState(() {
          _showControls = false;
        });
      },
    );
  }

  void _togglePlay() {
    if (_isPlaying) {
      _ticker.stop();

      setState(() {
        _isPlaying = false;
      });

      return;
    }

    _lastElapsed = null;

    setState(() {
      _isPlaying = true;
    });

    _ticker.start();
  }

  void _increaseFont() {
    setState(() {
      if (_lyricsFontSize < 48) {
        _lyricsFontSize += 2;
      }
    });
  }

  void _decreaseFont() {
    setState(() {
      if (_lyricsFontSize > 18) {
        _lyricsFontSize -= 2;
      }
    });
  }

  void _scrollToTop() {
    _ticker.stop();

    setState(() {
      _isPlaying = false;
    });

    _lastElapsed = null;

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  // Ouvre la fenêtre de choix de l'affichage.
  Future<void> _showExternalDisplayOptions() async {
    final choice = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF222222),
          title: const Text(
            "Affichage des paroles",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Où souhaitez-vous afficher les paroles de cette chanson ?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('cancel');
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('iphone');
              },
              child: const Text("Sur l’iPhone"),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.cast),
              label: const Text("Écran externe"),
              onPressed: () {
                Navigator.of(dialogContext).pop('external');
              },
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (choice == 'external') {
      await _connectExternalDisplay();
    }
  }

  // Vérifie les écrans, lance l'affichage externe
  // et lui transmet les paroles de la chanson.
  Future<void> _connectExternalDisplay() async {
    try {
      final screens = await externalDisplay.getScreen();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Écrans détectés : ${screens.length}"),
          duration: const Duration(seconds: 4),
        ),
      );

      await externalDisplay.connect();

      await externalDisplay.waitingTransferParametersReady(
        onReady: () {
          unawaited(
            externalDisplay.sendParameters(
              action: 'lyrics',
              value: widget.song.lyrics,
            ),
          );
        },
        onError: () {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "L’écran externe n’est pas prêt.",
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Connexion à l’écran externe impossible : $e",
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();

    WakelockPlus.disable();

    _ticker.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: _showControls
          ? AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              title: Text(widget.song.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.cast),
                  tooltip: "Écran externe",
                  onPressed: _showExternalDisplayOptions,
                ),
                IconButton(
                  icon: const Icon(Icons.vertical_align_top),
                  tooltip: "Début",
                  onPressed: _scrollToTop,
                ),
                IconButton(
                  icon: const Icon(Icons.text_decrease),
                  tooltip: "Réduire",
                  onPressed: _decreaseFont,
                ),
                IconButton(
                  icon: const Icon(Icons.text_increase),
                  tooltip: "Agrandir",
                  onPressed: _increaseFont,
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  tooltip: "Lecture",
                  onPressed: _togglePlay,
                ),
              ],
            )
          : null,

      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,

          onTap: () {
            _showControlsTemporarily();
          },

          onDoubleTap: () {
            _togglePlay();
          },

          child: Column(
            children: [
              if (_showControls)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.speed,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Slider(
                          value: _scrollSpeed,
                          min: 20,
                          max: 200,
                          divisions: 18,
                          label:
                              "${_scrollSpeed.toStringAsFixed(0)} px/s",
                          onChanged: (value) {
                            setState(() {
                              _scrollSpeed = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    if (_showControls)
                      const SizedBox(height: 12),

                    Theme(
                      data: Theme.of(context).copyWith(
                        textTheme:
                            Theme.of(context).textTheme.apply(
                                  bodyColor: Colors.white,
                                  displayColor: Colors.white,
                                ),
                      ),
                      child: ChordProViewer(
                        lyrics: widget.song.lyrics,
                        fontSize: _lyricsFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}