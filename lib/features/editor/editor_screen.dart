
import 'package:flutter/material.dart';

class EditorScreen extends StatefulWidget {
  final String initialLyrics;
  final ValueChanged<String> onSave;

  const EditorScreen({
    super.key,
    required this.initialLyrics,
    required this.onSave,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final TextEditingController _controller;

  static const List<String> _roots = [
    'C', 'C#', 'Db', 'D', 'D#', 'Eb',
    'E', 'F', 'F#', 'Gb', 'G', 'G#',
    'Ab', 'A', 'A#', 'Bb', 'B',
  ];

  static const Map<String, List<String>> _families = {
    'Tous les accords': [
      '',
      'm',
      '5',
      '6',
      'm6',
      '6/9',
      '7',
      'maj7',
      'm7',
      '9',
      'maj9',
      'm9',
      '11',
      'maj11',
      'm11',
      '13',
      'maj13',
      'm13',
      'dim',
      'dim7',
      'aug',
      'sus2',
      'sus4',
      'add2',
      'add4',
      'add9',
    ],
    'Majeurs et mineurs': [
      '',
      'm',
      '5',
      '6',
      'm6',
      '6/9',
      'add2',
      'add4',
      'add9',
    ],
    'Accords de 7e': [
      '7',
      'maj7',
      'm7',
      'dim7',
    ],
    'Accords étendus': [
      '9',
      'maj9',
      'm9',
      '11',
      'maj11',
      'm11',
      '13',
      'maj13',
      'm13',
      '6/9',
    ],
    'Suspendus': [
      'sus2',
      'sus4',
    ],
    'Diminués et augmentés': [
      'dim',
      'dim7',
      'aug',
    ],
  };

  String _selectedFamily = 'Tous les accords';
  String _search = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialLyrics);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> get _availableChords {
    final suffixes =
        _families[_selectedFamily] ?? _families['Tous les accords']!;

    return _roots
        .expand((root) => suffixes.map((suffix) => '$root$suffix'))
        .where(
          (chord) => chord.toLowerCase().contains(_search.toLowerCase()),
        )
        .toList();
  }

  Future<void> _addChord() async {
    final chord = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final chords = _availableChords;

            return AlertDialog(
              title: const Text('Ajouter un accord'),
              content: SizedBox(
                width: 440,
                height: 500,
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Rechercher (ex. F#m7, Bb, Cmaj9)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          _search = value.trim();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedFamily,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Famille d’accords',
                        border: OutlineInputBorder(),
                      ),
                      items: _families.keys.map((family) {
                        return DropdownMenuItem<String>(
                          value: family,
                          child: Text(family),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setDialogState(() {
                          _selectedFamily = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: chords.isEmpty
                          ? const Center(
                              child: Text('Aucun accord trouvé.'),
                            )
                          : GridView.builder(
                              itemCount: chords.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 1.25,
                                crossAxisSpacing: 6,
                                mainAxisSpacing: 6,
                              ),
                              itemBuilder: (context, index) {
                                final chord = chords[index];

                                return OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext, chord);
                                  },
                                  child: Text(
                                    chord,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Annuler'),
                ),
              ],
            );
          },
        );
      },
    );

    if (chord == null) return;

    final selection = _controller.selection;
    if (!selection.isValid) return;

    final start = selection.start;
    final end = selection.end;
    final text = _controller.text;

    final newText =
        '${text.substring(0, start)}[$chord]${text.substring(end)}';

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: start + chord.length + 2,
      ),
    );
  }

  void _save() {
    widget.onSave(_controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Éditeur d'accords"),
        actions: [
          IconButton(
            tooltip: 'Enregistrer',
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ajouter un accord',
        onPressed: _addChord,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: _controller,
          expands: true,
          maxLines: null,
          minLines: null,
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Écrivez vos paroles...',
            alignLabelWithHint: true,
          ),
        ),
      ),
    );
  }
}
