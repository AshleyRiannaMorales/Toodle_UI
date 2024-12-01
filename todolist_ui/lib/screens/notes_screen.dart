import 'package:flutter/material.dart';
import 'addnote_screen.dart'; // Import the AddNoteScreen
import '../widgets/notes_card.dart'; // Import your NotesCard widget
import 'viewnote_screen.dart'; // Import NoteDetailScreen

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // Initialize the notes list as an empty list
  List<Map<String, String>> notes = [];

  void _addNote(Map<String, String> note) {
    setState(() {
      notes.add(note); // Add the new note to the list
    });
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index); // Remove note at the specified index
    });
  }

  // Method to navigate to NoteDetailScreen
  void _viewNoteDetail(String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(title: title, content: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Write a Note',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromRGBO(56, 116, 120, 1)),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    // Navigate to AddNoteScreen and wait for the result
                    final newNote = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddNoteScreen()),
                    );

                    if (newNote != null) {
                      _addNote(newNote); // If a new note is added, update the notes list
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 5), // Space between header and list
            Expanded(
              child: notes.isEmpty
                  ? Center(
                      child: Text(
                        'Notes are empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notes.length, // Show the notes dynamically
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _viewNoteDetail(
                              notes[index]['title']!, notes[index]['content']!), // Navigate to NoteDetailScreen on tap
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.0), // Set left and right padding
                            child: NotesCard(
                              noteTitle: notes[index]['title']!,
                              noteContent: notes[index]['content']!,
                              onDelete: () => _deleteNote(index), // Handle delete action
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}