class Task {
  final int id;
  final String title;
  bool isCompleted;
  final int projectId;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false, 
    required this.projectId,
    this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      isCompleted: json['is_completed'] as bool,
      projectId: json['project_id'] as int,

      dueDate: json['due_date'] != null 
          ? DateTime.parse(json['due_date']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'is_completed': isCompleted,
      'project_id': projectId,
    };
  }

  Task copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    int? projectId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      projectId: projectId ?? this.projectId,
    );
  }
}