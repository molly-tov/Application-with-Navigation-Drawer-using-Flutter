import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(NotepadApp());

class NotepadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notepad',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Note> _notes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  int _noteIdCounter = 0;

  void _addNote() {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      setState(() {
        _notes.add(
          Note(
            id: _noteIdCounter++,
            title: _titleController.text,
            content: _contentController.text,
          ),
        );
        _titleController.clear();
        _contentController.clear();
      });
      Navigator.of(context).pop();
    }
  }

  void _showAddNoteDialog() {
    _titleController.clear();
    _contentController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addNote,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(Note note) {
    final TextEditingController _renameController = TextEditingController(text: note.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename Note'),
        content: TextField(
          controller: _renameController,
          decoration: InputDecoration(labelText: 'New Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                note.rename(_renameController.text);
              });
              Navigator.of(context).pop();
            },
            child: Text('Rename'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Notes App'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(child: Text('My Notes')),
              ListTile(
                leading: Icon(Icons.note),
                title: Text('All Notes'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Favorites'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: _notes.isEmpty
            ? Center(child: Text('No notes yet. Tap + to add one.'))
            : ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            note.isFavorite ? Icons.star : Icons.star_border,
                            color: note.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () {
                            setState(() {
                              note.isFavorite = !note.isFavorite;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showRenameDialog(note),
                        ),
                      ],
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddNoteDialog,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class NoteEditor extends StatefulWidget {
  final String? note;

  NoteEditor({this.note});

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      Navigator.pop(context, text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _save,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          autofocus: true,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Start typing...',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class Note {
  final int id;
  String title;
  String content;
  bool isFavorite;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.isFavorite = false,
  });

  void rename(String newTitle) {
    title = newTitle;
  }
}
