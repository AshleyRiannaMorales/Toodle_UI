import 'package:flutter/material.dart';
import '../widgets/task_card.dart';
import '../models/task_model.dart';
import 'taskdetails_screen.dart'; // Import the TaskDetailScreen

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [
    Task(
        title: 'Sample Task 0',
        category: 'School',
        dueDate: DateTime.now(),
        status: 'Pending'),
    Task(
        title: 'Sample Task 1',
        category: 'Work',
        dueDate: DateTime.now(),
        status: 'Pending'),
    Task(
        title: 'Sample Task 2',
        category: 'Personal',
        dueDate: DateTime.now(),
        status: 'Completed'),
  ];

  String? selectedFilterCategory;
  String? selectedFilterStatus;
  String searchQuery = '';

  void _toggleTaskStatus(int index, bool? value) {
    setState(() {
      tasks[index].status =
          value == true ? 'Completed' : 'Pending'; // Update task status
    });
  }

  List<Task> get filteredTasks {
    return tasks.where((task) {
      final matchesSearch =
          task.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedFilterCategory == null ||
          task.category == selectedFilterCategory;
      final matchesStatus =
          selectedFilterStatus == null || task.status == selectedFilterStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Tasks'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Category'),
                  value: selectedFilterCategory,
                  items: <String>['School', 'Work', 'Personal', 'Others'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFilterCategory = value;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Status'),
                  value: selectedFilterStatus,
                  items: <String>['Not Yet Started', 'Pending', 'Completed'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFilterStatus = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          onDelete: (deletedTask) {
            setState(() {
              tasks.remove(deletedTask); // Remove task from list
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0), // Adjust top padding here
          child: Text(
            'Tasks List',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Color.fromRGBO(56, 116, 120, 1),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Set padding for the entire row
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the row contents
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search Tasks',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value; // Update search query
                      });
                    },
                  ),
                ),
                SizedBox(width: 10), // Add space between search bar and filter button
                IconButton(
                  icon: Icon(Icons.filter_list), // Filter icon
                  onPressed: _showFilterDialog, // Show filter dialog
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return GestureDetector( // Wrap TaskCard with GestureDetector
                  onTap: () => _navigateToDetail(filteredTasks[index]), // Navigate on tap
                  child: TaskCard(
                    task: filteredTasks[index],
                    onChanged: (value) => _toggleTaskStatus(index, value), // Pass callback for checkbox
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}