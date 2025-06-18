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
  List<String> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = prefs.getStringList('notes') ?? [];
    });
  }

  void _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes', _notes);
  }

  void _addNote() async {
    final newNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteEditor()),
    );

    if (newNote != null) {
      setState(() {
        _notes.add(newNote);
        _saveNotes();
      });
    }
  }

  void _editNote(int index) async {
    final editedNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteEditor(note: _notes[index])),
    );

    if (editedNote != null) {
      setState(() {
        _notes[index] = editedNote;
        _saveNotes();
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
      _saveNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Show search bar or navigate to search page
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('My Notes')),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('All Notes'),
              onTap: () {
                // Show all notes
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Favorites'),
              onTap: () {
                // Show favorite notes
              },
            ),
            // Add more options if needed
          ],
        ),
      ),
      body: _notes.isEmpty
          ? Center(child: Text('No notes yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (_, index) => ListTile(
                title: Text(_notes[index]),
                onTap: () => _editNote(index),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteNote(index),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
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
