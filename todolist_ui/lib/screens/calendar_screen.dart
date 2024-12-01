import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task_model.dart';
import '../models/event_model.dart';
import '../providers/task_provider.dart';
import '../providers/event_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime selectedDay = DateTime.now();
  Map<DateTime, List<String>> tasksByDate = {}; // Tasks grouped by date
  Map<DateTime, List<String>> eventsByDate = {}; // Events grouped by date
  Map<String, bool> taskCheckboxes = {}; // Task checkbox states

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider); // Get current tasks
    final events = ref.watch(eventProvider); // Get current events

    // Update tasks and events when they change
    _initializeEventsAndTasks(tasks, events);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Calendar Overview',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Color.fromRGBO(56, 116, 120, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                });
              },
              eventLoader: (day) {
                final dayKey = DateTime(day.year, day.month, day.day);
                List<String> eventsForDay = eventsByDate[dayKey] ?? [];
                List<String> tasksForDay = tasksByDate[dayKey] ?? [];
                return [...tasksForDay, ...eventsForDay];
              },
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color.fromRGBO(56, 116, 120, 1),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true, // Center the Month and Year
              ),
              availableCalendarFormats: {
                CalendarFormat.month: 'Month',
              },
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  // Display tasks and events for the selected day
                  ..._getTasksAndEventsForSelectedDay()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Initialize both events and tasks, group them by date
  void _initializeEventsAndTasks(List<Task> tasks, List<Event> events) {
    tasksByDate.clear();
    eventsByDate.clear();
    taskCheckboxes.clear();

    // Group tasks by date
    for (final task in tasks) {
      final taskDate =
          DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      if (!tasksByDate.containsKey(taskDate)) {
        tasksByDate[taskDate] = [];
      }
      tasksByDate[taskDate]!.add(task.title);
      taskCheckboxes[task.title] = task.status == 'Completed';
    }

    // Group events by date (considering only the date portion of the DateTime)
    for (final event in events) {
      final eventDate = DateTime(
          event.dateTime.year, event.dateTime.month, event.dateTime.day);
      if (!eventsByDate.containsKey(eventDate)) {
        eventsByDate[eventDate] = [];
      }
      eventsByDate[eventDate]!.add(event.name);
    }

    setState(() {}); // Rebuild the widget with updated data
  }

  // Get tasks and events for the selected day
  List<Widget> _getTasksAndEventsForSelectedDay() {
    final tasks = ref.watch(taskProvider); // Access tasks via the provider
    List<Widget> widgets = [];

    // Display tasks
    final tasksForDay = tasksByDate[
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ??
        [];
    for (final task in tasksForDay) {
      widgets.add(Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(238, 239, 238, 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20.0,
              height: 20.0,
              child: Checkbox(
                value: taskCheckboxes[task],
                onChanged: (bool? value) {
                  setState(() {
                    taskCheckboxes[task] = value!;
                  });

                  // Find the task in the tasks list and update it
                  final taskToUpdate = tasks.firstWhere((t) => t.title == task);
                  ref.read(taskProvider.notifier).updateTask(
                        taskToUpdate.copyWith(
                          status: (value ?? false) ? 'Completed' : 'Pending',
                        ),
                      );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(task),
            ),
          ],
        ),
      ));
    }

    // Display events
    final eventsForDay = eventsByDate[
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ??
        [];
    for (final event in eventsForDay) {
      widgets.add(Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(
              226, 241, 231, 1), // Customize the color for events
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(Icons.event, size: 21.0), // Icon for event
            SizedBox(width: 8),
            Expanded(
              child: Text(event, style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ));
    }

    return widgets;
  }
}
