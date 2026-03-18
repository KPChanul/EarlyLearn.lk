import 'package:hive/hive.dart';

part 'child.g.dart';

@HiveType(typeId: 0)
class Child extends HiveObject {
  @HiveField(0)
  String _name;

  @HiveField(1)
  DateTime _dob;

  @HiveField(2)
  Map<int, int> _stages;

  // Constructor
  Child(this._name, this._dob, this._stages);

  // Factory for creating new child
  factory Child.create({required String name, required DateTime dob}) {
    return Child(name, dob, {1: 0, 2: 0, 3: 0});
  }

  // Getters
  String get name => _name;
  DateTime get dob => _dob;
  Map<int, int> get stages => _stages;

  int getAge() {
    DateTime now = DateTime.now();
    int age = now.year - _dob.year;
    if (now.month < _dob.month ||
        (now.month == _dob.month && now.day < _dob.day)) {
      age--;
    }
    return age;
  }

  void incrementStage(int stage) {
    if (_stages.containsKey(stage)) {
      _stages[stage] = _stages[stage]! + 1;
      save();
    } else {
      throw Exception("Stage $stage does not exist");
    }
  }

  int getStageValue(int stage) {
    if (_stages.containsKey(stage)) return _stages[stage]!;
    throw Exception("Stage $stage does not exist");
  }
}