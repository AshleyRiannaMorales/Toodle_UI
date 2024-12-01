import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';  // Ensure this includes all necessary properties like title, category, dueDate

class TaskCard extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;

  TaskCard({required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Format the due date
    String formattedDate = DateFormat('MMMM d').format(task.dueDate);

    // Define color based on category
    Color categoryColor;
    switch (task.category) {
      case 'School':
        categoryColor = Colors.blue; // Example color for School
        break;
      case 'Work':
        categoryColor = Colors.green; // Example color for Work
        break;
      case 'Home':
        categoryColor = Colors.orange; // Example color for Home
        break;
      default:
        categoryColor = Colors.grey; // Default color
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: ListTile(
        leading: Checkbox(
          value: task.status == 'Completed',
          onChanged: onChanged,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 14,
            decoration: task.status == 'Completed'
                ? TextDecoration.lineThrough
                : TextDecoration.none, // Strikethrough for completed tasks
          ),
        ),
        subtitle: Text('Due: $formattedDate'),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0), // Smaller padding
          decoration: BoxDecoration(
            color: categoryColor,
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Text(
            task.category,
            style: TextStyle(color: Colors.white, fontSize: 11), // Smaller font size
          ),
        ),
      ),
    );
  }
}

