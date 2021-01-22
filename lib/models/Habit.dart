class Habit {
  final int id;
  final String name;
  final int streak;
  final DateTime lastRecordedDate;

  Habit({this.id, this.name, this.streak, this.lastRecordedDate});

  //TODO "new" habit constructor

  //TODO improve
  // don't insert id if < 0
  Map<String, dynamic> toMap() {
    if (id >= 0) {
      return {
        'id': id,
        'name': name,
        'streak': streak,
        'lastRecordedDate': lastRecordedDate.millisecondsSinceEpoch
      };
    } else {
      return {
        'name': name,
        'streak': streak,
        'lastRecordedDate': lastRecordedDate.millisecondsSinceEpoch
      };
    }
  }

  // Implement toString to make it easier to see information about
  // each habit when using the print statement.
  @override
  String toString() {
    return 'Habit{id: $id, name: $name, streak: $streak, lastRecordedDate: $lastRecordedDate}';
  }
}