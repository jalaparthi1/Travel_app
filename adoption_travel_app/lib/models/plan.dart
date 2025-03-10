class Plan {
  String name;
  String description;
  DateTime date;
  bool isCompleted;
  String priority; // Low, Medium, High

  Plan({
    required this.name,
    required this.description,
    required this.date,
    this.isCompleted = false,
    this.priority = 'Medium',
  });

  String get status => isCompleted ? "Completed" : "Pending";
}
