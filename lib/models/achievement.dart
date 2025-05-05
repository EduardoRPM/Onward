import 'package:flutter/material.dart';

class AchievementLevel {
  final int level;
  final String description;
  final bool completed;

  AchievementLevel({
    required this.level,
    required this.description,
    required this.completed,
  });
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<AchievementLevel> levels;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.levels,
  });

  int get completedLevelsCount => levels.where((level) => level.completed).length;
  int get totalLevelsCount => levels.length;
  double get progressPercentage => completedLevelsCount / totalLevelsCount;
  bool get isFullyCompleted => completedLevelsCount == totalLevelsCount;
}
