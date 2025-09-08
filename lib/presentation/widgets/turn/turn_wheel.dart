import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../domain/entities/participant.dart';
import '../../../core/theme/app_colors.dart';

/// Animated turn wheel widget for participant selection
class TurnWheel extends StatefulWidget {
  final List<Participant> participants;
  final Participant? selectedParticipant;
  final bool isSpinning;
  final VoidCallback? onSpinComplete;
  final double size;

  const TurnWheel({
    super.key,
    required this.participants,
    this.selectedParticipant,
    this.isSpinning = false,
    this.onSpinComplete,
    this.size = 300,
  });

  @override
  State<TurnWheel> createState() => _TurnWheelState();
}

class _TurnWheelState extends State<TurnWheel> with TickerProviderStateMixin {
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 4000), // 4 seconds for better effect
      vsync: this,
    );

    // Create a more realistic spinning animation with deceleration
    _spinAnimation = Tween<double>(
      begin: 0.0,
      end: 6 * math.pi + (math.Random().nextDouble() * 2 * math.pi), // 3+ rotations with random final position
    ).animate(CurvedAnimation(
      parent: _spinController,
      curve: Curves.easeOutCubic, // Better deceleration curve
    ));

    _spinController.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          widget.onSpinComplete != null) {
        widget.onSpinComplete!();
      }
    });
  }

  @override
  void didUpdateWidget(TurnWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpinning && !oldWidget.isSpinning) {
      _spinController.reset();
      _spinController.forward();
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeParticipants =
        widget.participants.where((p) => p.isActive).toList();

    if (activeParticipants.isEmpty) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
            border: Border.all(color: Colors.grey.shade400, width: 2),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 48,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  'No active\nparticipants',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Spinning wheel
          AnimatedBuilder(
            animation: _spinAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _spinAnimation.value,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: WheelPainter(
                    participants: activeParticipants,
                    selectedParticipant: widget.selectedParticipant,
                  ),
                ),
              );
            },
          ),

          // Center pointer
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 24,
            ),
          ),

          // Selected participant indicator
          if (widget.selectedParticipant != null && !widget.isSpinning)
            Positioned(
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.selectedParticipant!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate().scale(delay: 500.ms, duration: 300.ms),
            ),
        ],
      ),
    );
  }
}

/// Custom painter for the wheel
class WheelPainter extends CustomPainter {
  final List<Participant> participants;
  final Participant? selectedParticipant;

  WheelPainter({
    required this.participants,
    this.selectedParticipant,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (participants.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10; // Leave some margin
    final sweepAngle = 2 * math.pi / participants.length;

    for (int i = 0; i < participants.length; i++) {
      final participant = participants[i];
      final startAngle = i * sweepAngle - math.pi / 2; // Start from top

      // Determine segment color
      Color segmentColor;
      if (participant.color != null) {
        segmentColor = Color(int.parse(
          participant.color!.replaceFirst('#', '0xFF'),
        ));
      } else {
        // Generate color based on index
        final hue = (i * 360 / participants.length) % 360;
        segmentColor = HSVColor.fromAHSV(1.0, hue, 0.7, 0.8).toColor();
      }

      // Highlight if selected
      if (participant == selectedParticipant) {
        segmentColor = segmentColor.withValues(alpha: 1.0);
      } else {
        segmentColor = segmentColor.withValues(alpha: 0.8);
      }

      // Draw segment
      final paint = Paint()
        ..color = segmentColor
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, paint);

      // Draw border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawPath(path, borderPaint);

      // Draw participant name
      final textAngle = startAngle + sweepAngle / 2;
      final textRadius = radius * 0.7;
      final textX = center.dx + math.cos(textAngle) * textRadius;
      final textY = center.dy + math.sin(textAngle) * textRadius;

      final textPainter = TextPainter(
        text: TextSpan(
          text: participant.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      // Save canvas state
      canvas.save();

      // Translate to text position
      canvas.translate(textX, textY);

      // Rotate text to be readable
      final rotationAngle = textAngle + math.pi / 2;
      if (rotationAngle > math.pi / 2 && rotationAngle < 3 * math.pi / 2) {
        canvas.rotate(rotationAngle + math.pi);
      } else {
        canvas.rotate(rotationAngle);
      }

      // Draw text centered
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      // Restore canvas state
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant WheelPainter oldDelegate) {
    return participants != oldDelegate.participants ||
        selectedParticipant != oldDelegate.selectedParticipant;
  }
}
