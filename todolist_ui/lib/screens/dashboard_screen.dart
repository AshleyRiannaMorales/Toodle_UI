import 'package:flutter/material.dart';
import '../utils/inspoquotes.dart';
import 'tasklist_screen.dart';
import 'calendar_screen.dart';
import 'new_task_event.dart';
import 'notes_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // List of screens to navigate between
  final List<Widget> _screens = [
    DashboardContent(), // The dashboard main content
    TaskListScreen(),
    AddTaskEventScreen(),
    CalendarScreen(),
    NotesScreen(),
  ];

  // Method to handle navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedIndex == 0 // Show AppBar only for Dashboard
    ? AppBar(
        backgroundColor: Color.fromRGBO(56, 116, 120, 1),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: Image.asset(
                'lib/assets/logonotext.png', // Correct path to your image
                height: 40, // Set height as needed
                width: 40, // Set width as needed
              ),
            ),
            SizedBox(width: 5), // Space between the image and text
            Text(
              'Toodle',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      )
    : null, // No AppBar for other screens
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white, // Ensure a contrasting background color
        selectedItemColor:
            Color.fromRGBO(56, 116, 120, 1), // Color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Notes',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

// Separate widget for Dashboard content for better management
class DashboardContent extends StatefulWidget {
  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  // ScrollControllers for managing scroll position
  final ScrollController _taskScrollController = ScrollController();
  final ScrollController _eventScrollController = ScrollController();

  // Dummy data for tasks and events
  final List<Map<String, dynamic>> todayTasks = [
    {'title': 'Buy groceries', 'category': 'Personal', 'completed': false},
    {
      'title': 'Finish Flutter assignment',
      'category': 'School',
      'completed': true
    },
    {'title': 'Call Alice', 'category': 'Personal', 'completed': false},
  ];

  final List<Map<String, dynamic>> upcomingEvents = [
    {'title': 'Meeting with Bob', 'date': 'Oct 28, 2024'},
    {'title': 'Doctor Appointment', 'date': 'Oct 29, 2024'},
    {'title': 'Gym Session', 'date': 'Oct 30, 2024'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            'Hello, User!',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(56, 116, 120, 1)),
          ),
          SizedBox(height: 14),

          // Inspirational Quote Box
          SizedBox(
            width: 340,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromRGBO(226, 241, 231, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                getDailyQuote(),
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ),
          ),

          // Today's Tasks
          SizedBox(height: 24),
          Text('Today\'s Tasks:', style: TextStyle(fontSize: 17)),
          SizedBox(height: 5),

          // List of Today's Tasks with checkboxes in a scrollable container
          Expanded(
            child: Scrollbar(
              // Add Scrollbar here for Today's Tasks
              thumbVisibility: true,
              controller: _taskScrollController,
              child: ListView.builder(
                controller:
                    _taskScrollController, // Attach controller to ListView
                itemCount: todayTasks.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(todayTasks[index]['title'],
                        style: TextStyle(fontSize: 14)),
                    subtitle: Text(todayTasks[index]['category'],
                        style: TextStyle(fontSize: 12)),
                    value: todayTasks[index]['completed'],
                    onChanged: (bool? newValue) {},
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
            ),
          ),

          // SizedBox(height: 5),

          const Divider(
            height: 50,
            thickness: 1,
            color: Color.fromARGB(255, 218, 218, 218),
          ),

          // Upcoming Events Section
          Text('Upcoming Events:', style: TextStyle(fontSize: 17)),
          SizedBox(height: 8),

          // List of Upcoming Events with Scrollbar
          Expanded(
            child: Scrollbar(
              // Add Scrollbar here for Upcoming Events
              thumbVisibility: true,
              controller: _eventScrollController,
              child: ListView.builder(
                controller:
                    _eventScrollController, // Attach controller to ListView
                itemCount: upcomingEvents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(upcomingEvents[index]['title'],
                        style: TextStyle(fontSize: 14)),
                    subtitle: Text(upcomingEvents[index]['date'],
                        style: TextStyle(fontSize: 12)),
                    leading: Icon(Icons.event),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
