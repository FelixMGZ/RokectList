class Project {
  final int id;
  final String title;
  final String subtitle;
  final int icon;
  final int color;
  
  final int totalTasks;
  final int completedTasks;

  Project({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.totalTasks = 0,
    this.completedTasks = 0,
  });

  double get progress => totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

  factory Project.fromJson(Map<String, dynamic> json) {
  
    final tasksList = json['tasks'] as List<dynamic>? ?? []; 
    int total = tasksList.length;
    int completed = tasksList.where((t) => t['is_completed'] == true).length;

    return Project(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      icon: json['icon_code'] as int,
      color: json['color_value'] as int,
      totalTasks: total,
      completedTasks: completed,
    );
  }
}