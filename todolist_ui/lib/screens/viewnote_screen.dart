import 'package:flutter/material.dart';

class NoteDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  NoteDetailScreen({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Set the background color of the entire screen to white
      appBar: AppBar(
        title: Text('Note Details'),
        backgroundColor: Colors.white,  // Set the app bar background to white
        elevation: 0,  // Remove elevation for a flat look
        iconTheme: IconThemeData(color: Colors.black), // Ensure icons are visible if using white app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Divider(),
              SizedBox(height: 10),
              // Content
              Text(
                content,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
