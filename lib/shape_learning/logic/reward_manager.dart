import '../data/local_storage.dart';

class RewardManager {
  final LocalStorage _storage = LocalStorage();

  void processGameResult(bool isPassed, int finalScore) {
    if (isPassed) {
      _storage.saveTotalScore(finalScore);
    }
  }
}
