import 'package:flutter/cupertino.dart';

import '../models/achievement.dart';
import '../services/AchievementService.dart';

class AchievementsNotifier extends ChangeNotifier {
  List<Achievement> _achievements = [];
  List<Achievement> get achievements => _achievements;

  String _userId = '';
  String get userId => _userId;

  AchievementsNotifier(this._userId);

  Future<void> loadAchievements([String? forUserId]) async {
    if (forUserId != null) {
      _userId = forUserId;
    }
    if (_userId.isEmpty) return;
    final service = AchievementService();
    _achievements = await service.getUserAchievements(_userId);
    notifyListeners();
  }
}

