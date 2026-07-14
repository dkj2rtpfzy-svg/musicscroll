import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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

  static const double _scrollSpeed = 0.8;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((_) {
      if (!_isPlaying) return;

      if (!_scrollController.hasClients) return;

      final position = _scrollController.offset + _scrollSpeed;

      if (position >= _scrollController.position.maxScrollExtent) {
        _isPlaying = false;
        _ticker.stop();
        setState(() {});
        return;
      }

      _scrollController.jumpTo(position);
    });
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _ticker.start();
    } else {
      _ticker.stop();
    }
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

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
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
                  onPressed: _decreaseFont,
                ),
                IconButton(
                  icon: const Icon(Icons.text_increase),
                  onPressed: _increaseFont,
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
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
      ),
    );
  }
}