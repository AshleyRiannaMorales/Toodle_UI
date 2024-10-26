import 'package:flutter/material.dart';
import '../screens/viewnote_screen.dart'; // Import the NoteDetailScreen

class NotesCard extends StatelessWidget {
  final String noteTitle;
  final String noteContent; // Added content parameter
  final Function onDelete; // Function to handle deletion

  NotesCard({
    required this.noteTitle,
    required this.noteContent,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1), // Bottom border for division
        ),
      ),
      child: ListTile(
        title: Text(
          noteTitle,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          noteContent.length > 30 
            ? '${noteContent.substring(0, 30)}...' 
            : noteContent, // Display snippet of content
          style: TextStyle(fontSize: 12),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Delete Note') {
              onDelete(); // Call the delete function
            }
          },
          itemBuilder: (BuildContext context) {
            return {'Delete Note'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
        onTap: () {
          // Navigate to detail screen with title and content
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailScreen(
                title: noteTitle,
                content: noteContent,
              ),
            ),
          );
        },
      ),
    );
  }
}