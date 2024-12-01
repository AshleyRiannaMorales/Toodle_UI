import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/inspoquotes.dart';
import 'tasklist_screen.dart';
import 'calendar_screen.dart';
import 'notes_screen.dart';
import '../providers/task_provider.dart';
import '../providers/event_provider.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Method to handle navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define screens inside the build method to ensure context and state are available
    final List<Widget> screens = [
      DashboardContent(),
      TaskListScreen(),
      CalendarScreen(),
      NotesScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Color.fromRGBO(56, 116, 120, 1),
              foregroundColor: Colors.white,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Image.asset(
                      'lib/assets/logonotext.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text('Toodle', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : null,
      body: screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromRGBO(56, 116, 120, 1),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'Notes'),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

class DashboardContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access tasks and events from the providers
    final tasks = ref.watch(taskProvider);
    final events = ref.watch(eventProvider);

    // Filter today's tasks
    final todayTasks = tasks.where((task) {
      final now = DateTime.now();
      return task.dueDate?.day == now.day &&
          task.dueDate?.month == now.month &&
          task.dueDate?.year == now.year;
    }).toList();

    // Sort upcoming events by date
    final sortedEvents = events..sort((a, b) => a.dateTime.compareTo(b.dateTime));

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

          // List of Today's Tasks with long press delete option
          Expanded(
            child: todayTasks.isEmpty
                ? Center(child: Text('No tasks for today.'))
                : Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      itemCount: todayTasks.length,
                      itemBuilder: (context, index) {
                        final task = todayTasks[index];
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete Task'),
                                  content: Text('Are you sure you want to delete this task?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        ref.read(taskProvider.notifier).deleteTask(task);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: CheckboxListTile(
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 14,
                                decoration: task.status == 'Completed'
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: task.category != null
                                ? Text(task.category!, style: TextStyle(fontSize: 12))
                                : null,
                            value: task.status == 'Completed',
                            onChanged: (bool? newValue) {
                              ref.read(taskProvider.notifier).updateTask(
                                    task.copyWith(
                                      status: newValue == true ? 'Completed' : 'Pending',
                                    ),
                                  );
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        );
                      },
                    ),
                  ),
          ),

          const Divider(
            height: 50,
            thickness: 1,
            color: Color.fromARGB(255, 218, 218, 218),
          ),

          // Upcoming Events Section
          Text('Upcoming Events:', style: TextStyle(fontSize: 17)),
          SizedBox(height: 8),

          Expanded(
            child: sortedEvents.isEmpty
                ? Center(child: Text('No upcoming events.'))
                : Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      itemCount: sortedEvents.length,
                      itemBuilder: (context, index) {
                        final event = sortedEvents[index];
                        final formattedDateTime =
                            DateFormat('MMMM d, y h:mm a').format(event.dateTime);

                        return ListTile(
                          title: Text(
                            event.name,
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            formattedDateTime,
                            style: TextStyle(fontSize: 12),
                          ),
                          leading: Icon(Icons.event),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete Event'),
                                  content: Text('Are you sure you want to delete this event?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        ref.read(eventProvider.notifier).deleteEvent(event);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
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