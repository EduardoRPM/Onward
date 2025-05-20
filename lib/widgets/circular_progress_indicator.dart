import 'dart:math';
import 'package:flutter/material.dart';

import '../constantes.dart';

class CustomCircularProgressIndicator extends StatefulWidget {
  final int value;
  final double size;
  final double strokeWidth;
  final bool completed;
  final bool showPercentage;

  const CustomCircularProgressIndicator({
    super.key,
    required this.value,
    this.size = 40,
    this.strokeWidth = 3,
    this.completed = false,
    this.showPercentage = true,
  });

  @override
  State<CustomCircularProgressIndicator> createState() => _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState extends State<CustomCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.value.toDouble(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(CustomCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: oldWidget.value.toDouble(),
        end: widget.value.toDouble(),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));

      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: [
              // Background Circle
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: CircleProgressPainter(
                  progress: 100,
                  progressColor: const Color(0xFFE5E7EB),
                  strokeWidth: widget.strokeWidth,
                ),
              ),

              // Progress Circle
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: CircleProgressPainter(
                  progress: _animation.value,
                  progressColor: widget.completed
                      ? Color1
                      : const Color(0xFF10B981),
                  strokeWidth: widget.strokeWidth,
                  useGlow: widget.completed,
                ),
              ),

              // Percentage Text
              if (widget.showPercentage)
                Center(
                  child: Text(
                    '${_animation.value.toInt()}%',
                    style: TextStyle(
                      fontSize: widget.size * 0.3,
                      fontWeight: FontWeight.w500,
                      color: widget.completed
                          ? Color3
                          : const Color(0xFF1F2937),
                    ),
                  ),
                ),

              // Completed Indicator (small check mark)
              if (widget.completed && !widget.showPercentage)
                Center(
                  child: Container(
                    width: widget.size * 0.5,
                    height: widget.size * 0.5,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color4,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final double strokeWidth;
  final bool useGlow;

  CircleProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.strokeWidth,
    this.useGlow = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // For glow effect
    if (useGlow) {
      final paint = Paint()
        ..color = progressColor.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 2
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, // Start from top
        2 * pi * (progress / 100),
        false,
        paint,
      );
    }

    // Main progress arc
    final paint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      2 * pi * (progress / 100),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.useGlow != useGlow;
  }
}
