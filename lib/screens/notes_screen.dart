import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/screens/components/my_drawer.dart';
import 'package:provider/provider.dart';
import '../db/app_database.dart';
import 'components/notes_title.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNoteDialog(context, db),
        child: const Icon(Icons.add,),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text("Notes",style: GoogleFonts.dmSerifText(
              fontSize: 48,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),),
          ),
          Expanded(
            child: StreamBuilder<List<Note>>(
              stream: db.watchNotes(),
              builder: (context, snapshot) {
                // Show error if there's one
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Show loading only while waiting for first data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  );
                }

                // If we have data (even if null), show it
                final notes = snapshot.data ?? [];

                if (notes.isEmpty) {
                  return Center(
                    child: Text(
                      'No notes yet',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NotesTitle(text: note.content,
                      onEditPressed: () {
                        _updateNoteDialog(context, db, note);
                      },
                      onDeletePressed: () {
                        db.deleteNote(note.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addNoteDialog(BuildContext context, AppDatabase db) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter note'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                db.addNote(text);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  void _updateNoteDialog(BuildContext context, AppDatabase db, Note note) {
    final controller = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter note'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                db.updateNote(note.id, text);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
