import 'package:flutter/material.dart';

class AddTaskEventScreen extends StatefulWidget {
  @override
  _AddTaskEventScreenState createState() => _AddTaskEventScreenState();
}

class _AddTaskEventScreenState extends State<AddTaskEventScreen> {
  bool isAddingTask = true; // State to toggle between task and event

  // Form fields for Task
  String taskTitle = '';
  String taskDescription = '';
  String taskCategory = 'School';
  DateTime? taskDueDate; // Due date for the task
  String taskStatus = 'Not Yet Started'; // Status of the task

  // Form fields for Event
  String eventName = '';
  String eventDescription = '';
  DateTime? eventDateTime; // Date and time for the event

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle buttons for Task/Event selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAddingTask = true; // Switch to Task form
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: 8.0), // Space between text and underline
                    child: Column(
                      children: [
                        Text(
                          'New Task',
                          style: TextStyle(fontSize: 18),
                        ),
                        Container(
                          height: 3, // Thickness of the underline
                          width:
                              isAddingTask ? 80 : 0, // Width of the underline
                          color: Color.fromRGBO(
                              56, 116, 120, 1), // Color of the underline
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16), // Space between buttons
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAddingTask = false; // Switch to Event form
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: 8.0), // Space between text and underline
                    child: Column(
                      children: [
                        Text(
                          'New Event',
                          style: TextStyle(fontSize: 18),
                        ),
                        Container(
                          height: 3, // Thickness of the underline
                          width:
                              !isAddingTask ? 87 : 0, // Width of the underline
                          color: Color.fromRGBO(
                              56, 116, 120, 1), // Color of the underline
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Conditional rendering based on selection
            if (isAddingTask) ...[
              buildTaskForm(),
            ] else ...[
              buildEventForm(),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildTaskForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Task Title'),
          onChanged: (value) => setState(() => taskTitle = value),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(labelText: 'Description'),
          onChanged: (value) => setState(() => taskDescription = value),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: null, // No default value
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
              setState(() {
                taskDueDate = selectedDate;
              });
            }
          },
          controller: TextEditingController(
              text: taskDueDate == null
                  ? ''
                  : '${taskDueDate!.toLocal()}'.split(' ')[0]),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: null, // No default value
          decoration: InputDecoration(labelText: 'Status'),
          items: ['Not Yet Started', 'Pending', 'Finished'].map((status) {
            return DropdownMenuItem(value: status, child: Text(status));
          }).toList(),
          onChanged: (value) => setState(() => taskStatus = value!),
        ),
        SizedBox(height: 50),
        Center(
            child: ElevatedButton(
          onPressed: () {
            // Save Task Logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color.fromRGBO(56, 116, 120, 1), // Background color
            foregroundColor: Colors.white, // Text color
          ),
          child: Text('Save Task'),
        )),
      ],
    );
  }

  Widget buildEventForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Event Name'),
          onChanged: (value) => setState(() => eventName = value),
        ),
        SizedBox(height: 16), // Space between fields
        TextFormField(
          decoration: InputDecoration(labelText: 'Event Description'),
          onChanged: (value) => setState(() => eventDescription = value),
        ),
        SizedBox(height: 16), // Space between fields
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(labelText: 'Event Date & Time'),
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: eventDateTime?.toLocal() ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101));

            if (selectedDate != null) {
              TimeOfDay? selectedTime = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());

              if (selectedTime != null) {
                final dateTime = DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, selectedTime.hour, selectedTime.minute);

                setState(() {
                  eventDateTime = dateTime;
                });
              }
            }
          },
          controller: TextEditingController(
              text: eventDateTime == null
                  ? ''
                  : '${eventDateTime!.toLocal().toString().split(' ')[0]} ${eventDateTime!.toLocal().hour}:${eventDateTime!.toLocal().minute.toString().padLeft(2, '0')}'), // Display only date and time in HH:mm format
        ),

        SizedBox(height: 50), // Space before the save button

        Center(
            // Centering the button
            child: ElevatedButton(
          onPressed: () {
            // Save Event Logic
            print('Saving Event...');
            print('Name:$eventName');
            print('Description:$eventDescription');
            print('Date & Time:${eventDateTime?.toLocal()}');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color.fromRGBO(56, 116, 120, 1), // Background color
            foregroundColor: Colors.white, // Text color
          ),
          child: Text('Save Event'),
        ))
      ],
    );
  }
}
