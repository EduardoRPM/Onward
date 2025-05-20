import 'package:flutter/material.dart';
import '../constantes.dart';
import '../models/achievement.dart';
import 'circular_progress_indicator.dart';

class AchievementCard extends StatefulWidget {
  final Achievement achievement;

  const AchievementCard({
    super.key,
    required this.achievement,
  });

  @override
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final achievement = widget.achievement;
    final isFullyCompleted = achievement.isFullyCompleted;
    final progress = achievement.progressPercentage * 100;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isFullyCompleted ? Color5 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFullyCompleted ? Color5 : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header
          InkWell(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isFullyCompleted
                          ? Color3
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      achievement.icon,
                      size: 24,
                      color: isFullyCompleted
                          ? Color5

                          : Colors.black54,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Title and Description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          achievement.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${achievement.completedLevelsCount} of ${achievement.totalLevelsCount} levels',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress Circle and Expand Icon
                  Row(
                    children: [
                      CustomCircularProgressIndicator(
                        value: progress.toInt(),
                        size: 44,
                        strokeWidth: 3,
                        completed: isFullyCompleted,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content
          AnimatedCrossFade(
            firstChild: const SizedBox(height: 0),
            secondChild: _buildExpandedContent(achievement),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(Achievement achievement) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFF3F4F6),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: achievement.levels.map((level) => _buildLevelItem(level)).toList(),
      ),
    );
  }

  Widget _buildLevelItem(AchievementLevel level) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          // Level Number or Check Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: level.completed
                  ? Color1
                  : const Color(0xFFF3F4F6),
              border: Border.all(
                color: level.completed
                    ? Color1
                    : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: Center(
              child: level.completed
                  ? const Icon(
                Icons.check,
                size: 16,
                color: Color1,
              )
                  : Text(
                level.level.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Level Description
          Expanded(
            child: Text(
              level.description,
              style: TextStyle(
                fontSize: 14,
                color: level.completed ? Colors.black87 : Colors.grey[600],
              ),
            ),
          ),

          // Level Progress Indicator
          CustomCircularProgressIndicator(
            value: level.completed ? 100 : 0,
            size: 28,
            strokeWidth: 2.5,
            completed: level.completed,
            showPercentage: false,
          ),
        ],
      ),
    );
  }
}
