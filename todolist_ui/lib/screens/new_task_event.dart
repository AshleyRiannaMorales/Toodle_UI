import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../models/event_model.dart';
import '../providers/task_provider.dart';
import '../providers/event_provider.dart';

class AddTaskEventScreen extends StatefulWidget {
  final VoidCallback
      onTaskSaved; // Callback to be triggered after saving a task

  AddTaskEventScreen({required this.onTaskSaved});

  @override
  _AddTaskEventScreenState createState() => _AddTaskEventScreenState();
}

class _AddTaskEventScreenState extends State<AddTaskEventScreen> {
  bool isAddingTask = true;

  // Form fields for Task
  String taskTitle = '';
  String taskCategory = 'School';
  DateTime? taskDueDate;
  String taskStatus = 'Pending';

  static int _counter = 0; // Counter to generate unique IDs

  // Form fields for Event
  String eventName = '';
  DateTime? eventDateTime; // Date and time for the event

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAddingTask ? 'New Task' : 'New Event'),
        backgroundColor: Colors.white,
        foregroundColor: Color.fromRGBO(56, 116, 120, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle between Task and Event
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => isAddingTask = true),
                  child: Column(
                    children: [
                      Text('New Task', style: TextStyle(fontSize: 18)),
                      Container(
                        height: 3,
                        width: isAddingTask ? 80 : 0,
                        color: Color.fromRGBO(56, 116, 120, 1),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () => setState(() => isAddingTask = false),
                  child: Column(
                    children: [
                      Text('New Event', style: TextStyle(fontSize: 18)),
                      Container(
                        height: 3,
                        width: !isAddingTask ? 87 : 0,
                        color: Color.fromRGBO(56, 116, 120, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Conditional rendering based on isAddingTask flag
            if (isAddingTask) buildTaskForm(), // Display Task form
            if (!isAddingTask) buildEventForm(), // Display Event form
          ],
        ),
      ),
    );
  }

  Widget buildTaskForm() {
    return Consumer(
      builder: (context, ref, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Task Title'),
              onChanged: (value) => setState(() => taskTitle = value),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: taskCategory,
              decoration: InputDecoration(labelText: 'Category'),
              items: ['School', 'Personal', 'Work', 'Others'].map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) => setState(() => taskCategory = value!),
            ),
            SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(labelText: 'Due Date'),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: taskDueDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  setState(() => taskDueDate = selectedDate);
                }
              },
              controller: TextEditingController(
                  text: taskDueDate == null
                      ? ''
                      : '${taskDueDate!.toLocal()}'.split(' ')[0]),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: taskStatus,
              decoration: InputDecoration(labelText: 'Status'),
              items: ['Pending', 'Completed'].map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (value) => setState(() => taskStatus = value!),
            ),
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (taskTitle.isNotEmpty && taskDueDate != null) {
                    // Generate a unique ID using the counter
                    _counter++; // Increment the counter
                    final taskId = _counter.toString(); // Convert to string

                    // Create and add the new task with the generated ID
                    ref.read(taskProvider.notifier).addTask(Task(
                          id: taskId, // Pass the generated ID
                          title: taskTitle,
                          category: taskCategory,
                          dueDate: taskDueDate!,
                          status: taskStatus,
                        ));

                    // Call the callback to update the selected index and navigate
                    widget
                        .onTaskSaved(); // Call the callback to navigate back to task list
                    Navigator.of(context).pop(); // Close the AddTaskEventScreen
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please fill all fields'),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(56, 116, 120, 1),
                  foregroundColor: Colors.white,
                ),
                child: Text('Save Task'),
              ),
            ),
          ],
        );
      },
    );
  }

  // Event form as per your first code
  Widget buildEventForm() {
    return Consumer(
      builder: (context, ref, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Event Name'),
              onChanged: (value) => setState(() => eventName = value),
            ),
            SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(labelText: 'Event Date & Time'),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: eventDateTime ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (selectedDate != null) {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (selectedTime != null) {
                    final dateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    setState(() => eventDateTime = dateTime);
                  }
                }
              },
              controller: TextEditingController(
                text: eventDateTime == null
                    ? ''
                    : '${eventDateTime!.toLocal()} ${eventDateTime!.hour}:${eventDateTime!.minute.toString().padLeft(2, '0')}',
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (eventName.isNotEmpty && eventDateTime != null) {
                    // Generate unique ID
                    final eventId =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    // Create and add event
                    ref.read(eventProvider.notifier).addEvent(
                          Event(
                            id: eventId,
                            name: eventName,
                            dateTime: eventDateTime!,
                          ),
                        );

                    widget.onTaskSaved(); // Trigger callback
                    Navigator.of(context).pop(); // Close screen
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please fill all fields'),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(56, 116, 120, 1),
                  foregroundColor: Colors.white,
                ),
                child: Text('Save Event'),
              ),
            ),
          ],
        );
      },
    );
  }
}
