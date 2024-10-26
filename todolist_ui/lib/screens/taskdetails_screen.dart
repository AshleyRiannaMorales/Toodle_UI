import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onDelete; // Callback to handle deletion

  TaskDetailScreen({required this.task, required this.onDelete});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.task.status; // Initialize with current task status
  }

  void _updateStatus(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedStatus = newValue; // Update status
      });
    }
  }

  void _deleteTask() {
    widget.onDelete(widget.task); // Call the delete callback
    Navigator.of(context).pop(); // Go back after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteTask, // Call delete function
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Category: ${widget.task.category}', style: TextStyle(fontSize: 15)),
            SizedBox(height: 8),
            Text('Due Date: ${widget.task.dueDate.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 15)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: InputDecoration(labelText: 'Status'),
              items: <String>['Not Yet Started', 'Pending', 'Finished'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: _updateStatus,
            ),
            SizedBox(height: 25),
            Text('Description:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            // Placeholder for task description
            Text('This is a sample description of the task.', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}