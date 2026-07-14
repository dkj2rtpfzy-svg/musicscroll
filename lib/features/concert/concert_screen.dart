import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../shared/models/song.dart';

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

  // Pixels par seconde
  double _scrollSpeed = 50;

  @override
  void initState() {
    super.initState();

    // Empêche l'écran de s'éteindre pendant le mode concert
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

        setState(() {
          _isPlaying = false;
        });

        return;
      }

      _scrollController.jumpTo(nextOffset);
    });
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

  @override
  void dispose() {
    // Restaure le comportement normal du téléphone
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
            setState(() {
              _showControls = !_showControls;
            });
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
                    if (_showControls) ...[
                      Text(
                        widget.song.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.song.artist,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                    Text(
                      widget.song.lyrics.isEmpty
                          ? "Aucune parole disponible."
                          : widget.song.lyrics,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _lyricsFontSize,
                        height: 1.8,
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