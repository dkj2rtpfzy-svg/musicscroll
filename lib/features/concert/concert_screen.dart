import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  // Affiche ou masque les commandes du mode Concert.
  bool _showControls = false;

  // Indique si le défilement automatique est en cours.
  bool _isPlaying = false;

  // Taille prévue pour le texte des paroles.
  double _lyricsFontSize = 28;

  // Contrôleur du défilement vertical.
  final ScrollController _scrollController = ScrollController();

  // Animation utilisée pour faire défiler les paroles.
  late final Ticker _ticker;

  // Temps du dernier rafraîchissement du défilement.
  Duration? _lastElapsed;

  // Vitesse de défilement en pixels par seconde.
  double _scrollSpeed = 50;

  // Minuteur permettant de masquer automatiquement les commandes.
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();

    // Empêche l'écran de s'éteindre pendant le mode Concert.
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

      if (nextOffset >=
          _scrollController.position.maxScrollExtent) {
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

  // Affiche les commandes pendant 3 secondes.
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

  // Lance ou arrête le défilement.
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

  // Augmente la taille du texte.
  void _increaseFont() {
    setState(() {
      if (_lyricsFontSize < 48) {
        _lyricsFontSize += 2;
      }
    });
  }

  // Diminue la taille du texte.
  void _decreaseFont() {
    setState(() {
      if (_lyricsFontSize > 18) {
        _lyricsFontSize -= 2;
      }
    });
  }

  // Retourne au début de la chanson.
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

  @override
  void dispose() {
    // Annule le minuteur s'il existe.
    _controlsTimer?.cancel();

    // Restaure le comportement normal de l'écran.
    WakelockPlus.disable();

    // Libère les ressources.
    _ticker.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // La barre supérieure n'est visible que lorsque les commandes
      // sont affichées.
      appBar: _showControls
          ? AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              title: Text(widget.song.title),
              actions: [
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

          // Un simple tap affiche les commandes.
          onTap: () {
  _showControlsTemporarily();
},

          // Un double tap lance ou arrête le défilement.
          onDoubleTap: () {
            _togglePlay();
          },

          child: Column(
            children: [
              // Réglage de la vitesse.
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

              // Zone des paroles.
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