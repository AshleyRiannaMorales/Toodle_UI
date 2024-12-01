import 'package:flutter/material.dart';

class AddNoteScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('New Note'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(),
              maxLines: 17, // Allow multiple lines for content
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _contentController.text.isNotEmpty) {
                  // Create a new note map
                  Map<String, String> newNote = {
                    'title': _titleController.text,
                    'content': _contentController.text,
                  };

                  // Return the new note to the previous screen
                  Navigator.pop(context, newNote);
                } else {
                  // Optionally show an error message if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in both fields')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(56, 116, 120, 1), // Background color
                foregroundColor: Colors.white, // Text color
              ),
              child: Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}