import 'package:hive/hive.dart';

part 'child.g.dart';

@HiveType(typeId: 0)
class Child extends HiveObject {
  @HiveField(0)
  String _name;

  @HiveField(1)
  DateTime _dob;

  @HiveField(2)
  Map<int, int> _stages; //indicate last completed level in each stage

  @HiveField(3)
  Map<String, int> _scores; //indicate scores for each levels

  // Constructor
  Child(this._name, this._dob, this._stages,this._scores);

  // Factory for creating new child
  factory Child.create({required String name, required DateTime dob}) {
    return Child(name, dob, {1: 0, 2: 0, 3: 0},{});
  }

  // Getters
  String get name => _name;
  DateTime get dob => _dob;
  

  //get the age of the child
  int getAge() {
    DateTime now = DateTime.now();
    int age = now.year - _dob.year;
    if (now.month < _dob.month ||
        (now.month == _dob.month && now.day < _dob.day)) {
      age--;
    }
    return age;
  }

  //increment the stage if passed
  void incrementStage(int stage) {
    if (_stages.containsKey(stage)) {
      _stages[stage] = _stages[stage]! + 1;
      save();
    } else {
      throw Exception("Stage $stage does not exist");
    }
  }

  //get the last level of the stage
  int getStageLevel(int stage) {
    if (_stages.containsKey(stage)) return _stages[stage]!;
    throw Exception("Stage $stage does not exist");
  }
  //get score of perticular level
  int getLevelScore(String level) {
  return _scores[level] ?? 0;  
  }
  //update the score
  Future<void> updateScore(String level, int score) async {
    if (!_scores.containsKey(level) || score > _scores[level]!) {
      _scores[level] = score;
      await save();
    }
  }

  //get full score of a perticular age
  int getFullScoreForStage(int stage) {
    int total = 0;
    final stagePrefix = stage.toString();
    for (final entry in _scores.entries) {
      if (entry.key.startsWith(stagePrefix)) {
        total += entry.value;
      }
    }

    return total;
  }

}