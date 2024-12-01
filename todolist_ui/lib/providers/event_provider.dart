import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';

class EventNotifier extends StateNotifier<List<Event>> {
  EventNotifier() : super([]);

  void addEvent(Event event) {
    state = [...state, event];
  }

  void deleteEvent(Event event) {
    state = state.where((e) => e.id != event.id).toList(); // Remove the event by ID
  }
}

final eventProvider = StateNotifierProvider<EventNotifier, List<Event>>(
  (ref) => EventNotifier(),
);
