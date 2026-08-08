final tableTodo = "todo";
final columnId = "id";
final columnTitle = "title";
final columnCategory = "category";
final columnPriority = "priority";
final columnDays = "days";
final columnIsCompleted = "isCompleted";
final columnTime = "time";

class Todo {

  int? id;
  final String title;
  final String category;
  final String priority;
  final String days;
  final bool isCompleted;
  final DateTime time;

  Todo({
    this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.days,
    required this.isCompleted,
    required this.time,
  });

  Map<String, Object?> toMap(){
    var map = <String, Object?>{
      columnTitle: title,
      columnCategory: category,
      columnPriority: priority,
      columnDays: days,
      columnIsCompleted: isCompleted ? 1 : 0,
      columnTime: time.toIso8601String()
    };
    if (id != null){
      map[columnId] = id;
    }
    return map;
  }

  static Todo fromMap(Map<String, Object?> map){
    return Todo(
        id: map[columnId] as int?,
        title: map[columnTitle] as String,
        category: map[columnCategory] as String,
        priority: map[columnPriority] as String,
        days: map[columnDays] as String,
        isCompleted: (map[columnIsCompleted] as int) == 1,
        time: DateTime.parse(map[columnTime] as String)
    );
  }

}