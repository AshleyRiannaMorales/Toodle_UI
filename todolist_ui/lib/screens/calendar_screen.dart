import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();
  Map<DateTime, List<String>> events = {
    DateTime.utc(2024, 10, 26): ['Task 1', 'Event 1'],
    DateTime.utc(2024, 10, 27): ['Task 2'],
  };

  Map<String, bool> taskCheckboxes = {
    'Task 1': false,
    'Task 2': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0), // Adjust top padding here
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
                return events[day] ?? [];
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
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: (events[selectedDay] ?? []).map((event) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 8.0), // Space between containers
                    padding:
                        EdgeInsets.all(12.0), // Padding inside the container
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(226, 241, 231, 1),
                      borderRadius: BorderRadius.circular(8.0),
                      /* boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],*/
                    ),
                    child: event.startsWith('Task')
                        ? Row(
                            children: [
                              SizedBox(
                                width: 20.0, // Desired width
                                height: 20.0, // Desired height
                                child: Checkbox(
                                  value: taskCheckboxes[event],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      taskCheckboxes[event] = value!;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left:
                                        10.0), // Space between checkbox and task text
                                child: Text(event), // Task text
                              ),
                            ],
                          )
                        : Row(
                            // Use Row for events as well for consistency
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 21.0), // Optional icon for events
                              SizedBox(width: 8), // Space between icon and text
                              Expanded(
                                child:
                                    Text(event, style: TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
