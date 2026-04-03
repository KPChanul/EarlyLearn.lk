import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  final String _scoreBoxName = 'userScoreBox';
  // v4 forces the phone to download the new Level 2 data!
  final String _gameDataBoxName = 'gameDataBox_v4';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_scoreBoxName);
    var gameBox = await Hive.openBox(_gameDataBoxName);

    if (gameBox.isEmpty) {
      await _seedGameDatabase(gameBox);
    }
  }

  Future<void> _seedGameDatabase(Box box) async {
    // --- LEVEL 1 DATA ---
    List<Map<String, dynamic>> level1Data = [
      {
        'question': 'රවුම සොයන්න (Find the Circle)',
        'options': ['square', 'circle', 'triangle', 'star'],
        'correctIndex': 1,
        'hint': 'එය බෝලයක් වගේ!',
      },
      {
        'question': 'කොටුව සොයන්න (Find the Square)',
        'options': ['triangle', 'star', 'square', 'heart'],
        'correctIndex': 2,
        'hint': 'එය පෙට්ටියක් වගේ!',
      },
      {
        'question': 'ත්‍රිකෝණය සොයන්න (Find the Triangle)',
        'options': ['triangle', 'circle', 'heart', 'square'],
        'correctIndex': 0,
        'hint': 'එය වහලයක් වගේ!',
      },
      {
        'question': 'තරුව සොයන්න (Find the Star)',
        'options': ['square', 'star', 'circle', 'triangle'],
        'correctIndex': 1,
        'hint': 'එය අහසේ බබළනවා!',
      },
      {
        'question': 'හදවත සොයන්න (Find the Heart)',
        'options': ['heart', 'triangle', 'square', 'circle'],
        'correctIndex': 0,
        'hint': 'එය ආදරය පෙන්වයි!',
      },
    ];
    await box.put('level_1_quiz', level1Data);

    // --- LEVEL 2 DATA ---
    List<Map<String, dynamic>> level2Data = [
      {'emoji': '🍕', 'type': 'triangle', 'name': 'පීසා (Pizza)'},
      {'emoji': '⚽', 'type': 'circle', 'name': 'බෝලය (Ball)'},
      {'emoji': '🎁', 'type': 'square', 'name': 'තෑග්ග (Gift)'},
      {'emoji': '⏰', 'type': 'circle', 'name': 'ඔරලෝසුව (Clock)'},
      {'emoji': '📺', 'type': 'square', 'name': 'රූපවාහිනිය (TV)'},
    ];
    await box.put('level_2_quiz', level2Data);
  }

  List<Map<String, dynamic>> getLevelData(int level) {
    var box = Hive.box(_gameDataBoxName);
    var rawData = box.get('level_${level}_quiz', defaultValue: []);
    List<Map<String, dynamic>> parsedData = [];
    for (var item in rawData) {
      parsedData.add(Map<String, dynamic>.from(item));
    }
    return parsedData;
  }

  void saveTotalScore(int points) {
    var box = Hive.box(_scoreBoxName);
    int currentScore = box.get('total_score', defaultValue: 0);
    box.put('total_score', currentScore + points);
  }

  int getTotalScore() {
    var box = Hive.box(_scoreBoxName);
    return box.get('total_score', defaultValue: 0);
  }
}
