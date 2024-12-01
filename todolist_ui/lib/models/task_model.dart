class Task {
  final String id;
  final String title;
  final String category;
  final DateTime dueDate;
  final String status;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.status,
  });

  // Add the copyWith method
  Task copyWith({
    String? id,
    String? title,
    String? category,
    DateTime? dueDate,
    String? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }
}

