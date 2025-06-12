import 'package:flutter/material.dart';

void main() => runApp(QuickNotesApp());

// Public app class used in tests
class QuickNotesApp extends StatelessWidget {
  const QuickNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'QuickNotes', home: NotesListPage());
  }
}

// Model class
class Note {
  final String title;
  final String description;
  Note({required this.title, required this.description});
}

// Public widget class (important: no underscore)
class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});
  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  List<Note> notes = [];

  void addNote(Note note) {
    setState(() => notes.add(note));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QuickNotes')),
      body: notes.isEmpty
          ? Center(child: Text('No notes yet'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index].title),
                  subtitle: Text(notes[index].description),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
          if (result != null && result is Note) {
            addNote(result);
          }
        },
      ),
    );
  }
}

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});
  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  String title = '', description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Note')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (v) => title = v ?? '',
                validator: (v) => v!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (v) => description = v ?? '',
                validator: (v) => v!.isEmpty ? 'Enter description' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(
                      context,
                      Note(title: title, description: description),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
