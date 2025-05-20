import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/achievement.dart';
import '../notifiers/AchievementsNotifier.dart';
import 'achievement_card.dart';

class AchievementList extends StatelessWidget {
  const AchievementList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementsNotifier>(
      builder: (context, notifier, _) {
        final achievements = notifier.achievements;

        if (achievements.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AchievementCard(achievement: achievements[index]),
            );
          },
        );
      },
    );
  }
}
