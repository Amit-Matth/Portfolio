import 'package:flutter/material.dart';
import 'dart:ui';

class AnimatedBorderGlassCard extends StatefulWidget {
  final Widget child;
  final BorderRadius animatedBorderRadius;
  final BorderRadius glassCardBorderRadius;
  final EdgeInsets glassCardPadding;
  final double borderThickness;

  const AnimatedBorderGlassCard({
    Key? key,
    required this.child,
    required this.animatedBorderRadius,
    required this.glassCardBorderRadius,
    required this.glassCardPadding,
    this.borderThickness = 2.0,
  }) : super(key: key);

  @override
  _AnimatedBorderGlassCardState createState() => _AnimatedBorderGlassCardState();
}

class _AnimatedBorderGlassCardState extends State<AnimatedBorderGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ClipRRect(
        borderRadius: widget.glassCardBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: CustomPaint(
            painter: _AnimatedBorderPainter(
              animation: _animation,
              borderRadius: widget.animatedBorderRadius,
              strokeWidth: widget.borderThickness,
            ),
            child: Container(
              padding: widget.glassCardPadding,
              decoration: BoxDecoration(
                borderRadius: widget.glassCardBorderRadius,
                color: Colors.white.withOpacity(0.08),
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedBorderPainter extends CustomPainter {
  final Animation<double> animation;
  final BorderRadius borderRadius;
  final double strokeWidth;

  _AnimatedBorderPainter({
    required this.animation,
    required this.borderRadius,
    required this.strokeWidth,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = const LinearGradient(
        colors: [Colors.blue, Colors.purple, Colors.red],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final double progress = animation.value;

    if (progress > 0) {
      final startX = size.width / 2 * (1 - progress);
      final endX = size.width - startX;

      path.moveTo(startX, size.height);
      path.lineTo(endX, size.height);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_AnimatedBorderPainter oldDelegate) => false;
}
