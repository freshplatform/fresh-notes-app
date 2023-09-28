import 'package:flutter/material.dart';
import 'package:my_notes/screens/dashboard/widgets/notes/w_note_item.dart';
import 'package:my_notes/services/data/notes/s_notes_data.dart';

import '../../../../models/note/m_note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage>
    with AutomaticKeepAliveClientMixin {
  late final NotesDataService _notesDataService;
  late final Stream<List<Note>> _noteStream;

  @override
  void initState() {
    super.initState();
    _notesDataService = NotesDataService.getInstance();
    _notesDataService.loadNotesAndCacheThem();
    _noteStream = _notesDataService.notesStreamController.stream;
  }

  @override
  void dispose() {
    _notesDataService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _noteStream,
      initialData: const <Note>[],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final notes = snapshot.requireData;

        if (notes.isEmpty) {
          return const Center(
            child: Text("You don't have any notes yet, start add some!"),
          );
        }

        return ListView.builder(
          itemCount: notes.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final note = notes[index];
            return NoteItem(
              key: ValueKey(note.id),
              notesDataService: _notesDataService,
              note: note,
              index: index,
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
