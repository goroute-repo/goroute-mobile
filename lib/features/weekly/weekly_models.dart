class WeeklyTask {
  const WeeklyTask({
    required this.id,
    required this.type,
    required this.title,
    required this.skillSlug,
    required this.completed,
    required this.sortOrder,
    this.description,
  });

  final String id;
  final String type;
  final String title;
  final String? description;
  final String skillSlug;
  final bool completed;
  final int sortOrder;

  factory WeeklyTask.fromJson(Map<String, dynamic> json) {
    return WeeklyTask(
      id: (json['id'] as String?) ?? '',
      type: (json['type'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      description: json['description'] as String?,
      skillSlug: (json['skillSlug'] as String?) ?? '',
      completed: json['completed'] == true,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}

class WeeklyPlan {
  const WeeklyPlan({
    required this.weekKey,
    required this.status,
    required this.weekFocusLabel,
    required this.tasks,
    required this.progressPercent,
    required this.allTasksCompleted,
  });

  final String weekKey;
  final String status;
  final String weekFocusLabel;
  final List<WeeklyTask> tasks;
  final int progressPercent;
  final bool allTasksCompleted;

  factory WeeklyPlan.fromJson(Map<String, dynamic> json) {
    final focus = json['weekFocus'] as Map<String, dynamic>? ?? {};
    final rawTasks = json['tasks'];
    final tasks = rawTasks is List
        ? rawTasks
            .whereType<Map>()
            .map((e) => WeeklyTask.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <WeeklyTask>[];
    tasks.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return WeeklyPlan(
      weekKey: (json['weekKey'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      weekFocusLabel: (focus['label'] as String?) ?? '',
      tasks: tasks,
      progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
      allTasksCompleted: json['allTasksCompleted'] == true,
    );
  }
}
