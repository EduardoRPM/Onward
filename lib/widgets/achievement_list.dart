import 'package:flutter/material.dart';
import '../models/achievement.dart';
import 'achievement_card.dart';

class AchievementList extends StatelessWidget {
  const AchievementList({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      Achievement(
        id: 'first-step',
        title: 'First Step',
        description: 'Begin your walking journey',
        icon: Icons.directions_walk,
        levels: [
          AchievementLevel(
            level: 1,
            description: 'Walk 1,000 steps in a day',
            completed: true,
          ),
          AchievementLevel(
            level: 2,
            description: 'Walk 5,000 steps in a day',
            completed: true,
          ),
          AchievementLevel(
            level: 3,
            description: 'Walk 10,000 steps in a day',
            completed: false,
          ),
        ],
      ),
      Achievement(
        id: 'early-bird',
        title: 'Early Bird',
        description: 'Complete walks in the morning',
        icon: Icons.access_alarm,
        levels: [
          AchievementLevel(
            level: 1,
            description: 'Complete a walk before 8 AM',
            completed: true,
          ),
          AchievementLevel(
            level: 2,
            description: 'Complete 5 walks before 8 AM',
            completed: false,
          ),
          AchievementLevel(
            level: 3,
            description: 'Complete 20 walks before 8 AM',
            completed: false,
          ),
        ],
      ),
      Achievement(
        id: 'brave-rain',
        title: 'Brave in the Rain',
        description: "Don't let weather stop you",
        icon: Icons.cloud_outlined,
        levels: [
          AchievementLevel(
            level: 1,
            description: 'Walk 2,000 steps during rain',
            completed: true,
          ),
          AchievementLevel(
            level: 2,
            description: 'Walk 5,000 steps during rain',
            completed: false,
          ),
          AchievementLevel(
            level: 3,
            description: 'Walk 10,000 steps during heavy rain',
            completed: false,
          ),
        ],
      ),
      Achievement(
        id: 'explorer',
        title: '5K Explorer',
        description: 'Reach distance milestones',
        icon: Icons.landscape,
        levels: [
          AchievementLevel(
            level: 1,
            description: 'Walk 5 kilometers total',
            completed: true,
          ),
          AchievementLevel(
            level: 2,
            description: 'Walk 50 kilometers total',
            completed: true,
          ),
          AchievementLevel(
            level: 3,
            description: 'Walk 100 kilometers total',
            completed: true,
          ),
        ],
      ),
      Achievement(
        id: 'streak-master',
        title: 'Streak Master',
        description: 'Maintain your walking habit',
        icon: Icons.bolt,
        levels: [
          AchievementLevel(
            level: 1,
            description: 'Walk for 7 consecutive days',
            completed: true,
          ),
          AchievementLevel(
            level: 2,
            description: 'Walk for 30 consecutive days',
            completed: false,
          ),
          AchievementLevel(
            level: 3,
            description: 'Walk for 100 consecutive days',
            completed: false,
          ),
        ],
      ),
      Achievement(
        id: 'day-night',
        title: 'Day & Night Walker',
        description: 'Walk at different times of day',
        icon: Icons.wb_sunny,
        levels: [
          AchievementLevel(
            level: 1,
            description: 'Complete walks during daytime',
            completed: true,
          ),
          AchievementLevel(
            level: 2,
            description: 'Complete walks during evening',
            completed: true,
          ),
          AchievementLevel(
            level: 3,
            description: 'Complete walks at night',
            completed: false,
          ),
        ],
      ),
    ];

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
  }
}
