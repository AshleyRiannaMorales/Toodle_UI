import 'package:flutter/material.dart';
import 'addnote_screen.dart'; // Import the AddNoteScreen
import '../widgets/notes_card.dart'; // Import your NotesCard widget

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, String>> notes = [
    {
      'title': 'Meeting Notes',
      'content': 'Discuss project milestones and deadlines.',
    },
    {
      'title': 'Grocery List',
      'content': 'Eggs, Milk, Bread, Butter',
    },
    {
      'title': 'Workout Plan',
      'content': 'Monday: Chest, Tuesday: Back, Wednesday: Legs',
    },
  ]; // Dummy data for notes

  void _addNote(Map<String, String> note) {
    setState(() {
      notes.add(note); // Add note to the list
    });
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index); // Remove note at the specified index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text('My Notes'),
      ),*/
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

                    // If a new note is returned, add it to the list
                    if (newNote != null) {
                      _addNote(newNote);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 5), // Space between header and list
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0), // Set left and right padding
                    child: NotesCard(
                      noteTitle: notes[index]['title']!,
                      noteContent: notes[index]['content']!,
                      onDelete: () =>
                          _deleteNote(index), // Handle delete action
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
