import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({Key? key}) : super(key: key);

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _glitchController;

  Offset _mousePos = Offset.zero;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _glitchController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isSmallScreen ? 20 : 80,
      ),
      child: Column(
        children: [
          GradientText(
            text: 'Relevant Experience',
            gradient: AppTheme.primaryGradient,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: isSmallScreen ? 32 : 56,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Hover to orbit the experience',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.mutedForeground,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 100),
          _build3DScene(context, isSmallScreen),
        ],
      ),
    );
  }

  Widget _build3DScene(BuildContext context, bool isSmallScreen) {
    final size = MediaQuery.of(context).size;
    final sceneWidth = isSmallScreen ? size.width * 0.95 : 1200.0;
    final sceneHeight = isSmallScreen ? 700.0 : 600.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() {
        _isHovering = false;
        _mousePos = Offset.zero;
      }),
      onHover: (event) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPos = box.globalToLocal(event.position);
        setState(() {
          _mousePos = Offset(
            (localPos.dx - box.size.width / 2) / (box.size.width / 2),
            (localPos.dy - box.size.height / 2) / (box.size.height / 2),
          );
        });
      },
      child: TweenAnimationBuilder<Offset>(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        tween: Tween(
            begin: Offset.zero, end: _isHovering ? _mousePos : Offset.zero),
        builder: (context, mouseOffset, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0008) // perspective
              ..rotateX(-mouseOffset.dy * 0.15)
              ..rotateY(mouseOffset.dx * 0.2),
            child: SizedBox(
              width: sceneWidth,
              height: sceneHeight,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // 1. DATA STREAM / STARFIELD (Deep Background)
                  _buildDeepBackground(mouseOffset),

                  // 2. GRID & GLOW (Mid Background)
                  _buildBackgroundEffects(mouseOffset),

                  // 3. UNDERLAY ORBS
                  _buildDecorativeElements(mouseOffset, isFront: false),

                  // 4. CERTIFICATE PANEL (Mid depth)
                  _buildFloatingCertificate(mouseOffset, isSmallScreen),

                  // 5. NEURAL ENERGY LINK
                  _buildConnectingRope(mouseOffset, isSmallScreen),

                  // 6. MAIN CONTENT (Front depth)
                  _buildFloatingContent(mouseOffset, isSmallScreen),

                  // 7. OVERLAY ORBS & TECH NODES
                  _buildDecorativeElements(mouseOffset, isFront: true),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeepBackground(Offset mouseOffset) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(mouseOffset.dx * -50, mouseOffset.dy * -50, -200)
            ..rotateZ(_rotationController.value * 0.1),
          child: Opacity(
            opacity: 0.3,
            child: CustomPaint(
              size: const Size(1200, 800),
              painter: _TechParticlePainter(
                progress: _rotationController.value,
                color: AppTheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackgroundEffects(Offset mouseOffset) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(mouseOffset.dx * -30, mouseOffset.dy * -30, -50),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radial Glow
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 800,
                height: 600,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primary
                          .withOpacity(0.1 + (_pulseController.value * 0.05)),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),
          // Tech Grid
          CustomPaint(
            size: const Size(1200, 800),
            painter: _GridPainter(
              color: AppTheme.primary.withOpacity(0.08),
              spacing: 60,
              mousePos: mouseOffset,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCertificate(Offset mouseOffset, bool isSmallScreen) {
    final xOffset = isSmallScreen ? 0.0 : -320.0;
    final yOffset = isSmallScreen ? -220.0 : 0.0;

    return Transform(
      transform: Matrix4.identity()
        ..translate(
          xOffset + (mouseOffset.dx * 20),
          yOffset + (mouseOffset.dy * 20),
          60,
        )
        ..rotateZ(mouseOffset.dx * 0.02),
      child: GestureDetector(
        onTap: () => _showImageDialog(context),
        child: Hero(
          tag: 'certificateHero',
          child: Stack(
            children: [
              Container(
                width: isSmallScreen ? 280 : 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.2),
                      blurRadius: 40,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: Colors.white.withOpacity(0.05), // Subtle backing
                        child: SvgPicture.asset(
                          'assets/completion_certificate_2025_svg.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                      // Holographic overlay
                      Positioned.fill(
                        child: _buildHolographicEffect(),
                      ),
                      // Scanline effect
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ScanlinePainter(
                              color: AppTheme.primary.withOpacity(0.05)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingContent(Offset mouseOffset, bool isSmallScreen) {
    final xOffset = isSmallScreen ? 0.0 : 320.0;
    final yOffset = isSmallScreen ? 200.0 : 0.0;

    return Transform(
      transform: Matrix4.identity()
        ..translate(
          xOffset + (mouseOffset.dx * -30),
          yOffset + (mouseOffset.dy * -30),
          100, // Reduced Z-depth for stability
        ),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(32),
            width: isSmallScreen ? 340 : 540,
            decoration: BoxDecoration(
              color: AppTheme.card.withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.primary.withOpacity(0.2 +
                    (0.2 * Curves.easeInOut.transform(_pulseController.value))),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 50,
                  offset: Offset(mouseOffset.dx * 15, mouseOffset.dy * 15),
                ),
              ],
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            // Internal Holographic Flicker
            _buildInternalGlow(mouseOffset),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTheme.primary.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.workspace_premium,
                          color: AppTheme.primary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GSOC 2025 Contributor',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                          ),
                          Text(
                            'Google Summer of Code',
                            style: TextStyle(
                              color: AppTheme.primary.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'International Catrobat Association',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Divider(color: AppTheme.border, height: 32),
                _buildExperiencePoint(
                    'Revived Paintroid in Flutter with modern architecture.'),
                _buildExperiencePoint(
                    'Implemented Smart Bounding Box & Shape Tools.'),
                _buildExperiencePoint(
                    'Enabled .ORA Export for professional workflows.'),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'Project Summary',
                        Icons.description_outlined,
                        'https://gist.github.com/your-gist-link',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        'View PRs',
                        Icons.code,
                        'https://github.com/Catrobat/Paintroid-Flutter/pulls?q=is%3Apr+author%3Ayourusername',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHolographicEffect() {
    return AnimatedBuilder(
      animation: _glitchController,
      builder: (context, child) {
        return Opacity(
          opacity: 0.1 * _glitchController.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.transparent,
                  AppTheme.primary.withOpacity(0.5),
                ],
                stops: [
                  _glitchController.value,
                  _glitchController.value + 0.1,
                  _glitchController.value + 0.2,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInternalGlow(Offset mouseOffset) {
    return Positioned(
      top: -100,
      right: -100,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primary.withOpacity(0.1 * _pulseController.value),
                  Colors.transparent,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExperiencePoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.chevron_right, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppTheme.foreground.withOpacity(0.9),
                fontSize: 14, // Approximate bodyMedium size
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeElements(Offset mouseOffset, {required bool isFront}) {
    return Stack(
      children: [
        // Orbiting Tech Nodes
        _buildOrbitingNode(
          mouseOffset,
          radius: isFront ? 350 : 500,
          speed: 1.5,
          size: isFront ? 40 : 20,
          color: AppTheme.primary.withOpacity(isFront ? 0.3 : 0.1),
          icon: Icons.auto_awesome,
          z: isFront ? 200 : -150,
        ),
        _buildOrbitingNode(
          mouseOffset,
          radius: isFront ? 420 : 550,
          speed: -1.0,
          size: isFront ? 30 : 15,
          color: AppTheme.secondary.withOpacity(isFront ? 0.2 : 0.05),
          icon: Icons.code,
          z: isFront ? 180 : -180,
          phase: math.pi,
        ),
        if (isFront) ...[
          // Floating Cube 1 - Top Left
          _buildRotatingShape(
            Offset(mouseOffset.dx * 80 - 550, mouseOffset.dy * 80 - 280),
            60,
            AppTheme.primary.withOpacity(0.2),
            220,
          ),
          // Floating Cube 2 - Bottom Right
          _buildRotatingShape(
            Offset(mouseOffset.dx * -60 + 550, mouseOffset.dy * -60 + 280),
            40,
            AppTheme.secondary.withOpacity(0.15),
            250,
          ),
        ],
      ],
    );
  }

  Widget _buildOrbitingNode(
    Offset mouseOffset, {
    required double radius,
    required double speed,
    required double size,
    required Color color,
    required IconData icon,
    required double z,
    double phase = 0,
  }) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        final angle = _rotationController.value * 2 * math.pi * speed + phase;
        final x = math.cos(angle) * radius;
        final y = math.sin(angle) * (radius * 0.4);

        return Transform(
          transform: Matrix4.identity()
            ..translate(
              x + (mouseOffset.dx * (z * 0.1)),
              y + (mouseOffset.dy * (z * 0.1)),
              z,
            ),
          alignment: Alignment.center,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2)
              ],
            ),
            child: Icon(icon,
                color: Colors.white.withOpacity(0.5), size: size * 0.6),
          ),
        );
      },
    );
  }

  Widget _buildRotatingShape(
      Offset position, double size, Color color, double z) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(position.dx, position.dy, z)
            ..rotateX(_rotationController.value * 2 * math.pi)
            ..rotateZ(_rotationController.value * math.pi),
          alignment: Alignment.center,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectingRope(Offset mouseOffset, bool isSmallScreen) {
    final size = MediaQuery.of(context).size;
    final sceneWidth = isSmallScreen ? size.width * 0.95 : 1200.0;
    final sceneHeight = isSmallScreen ? 700.0 : 600.0;

    final centerX = sceneWidth / 2;
    final centerY = sceneHeight / 2;

    // Anchor points must match the cards' Z-depth to avoid parallax drift
    final xOffset1 = isSmallScreen ? 0.0 : -320.0;
    final yOffset1 = isSmallScreen ? -220.0 : 0.0;
    // Certificate is at Z=60, Content at Z=100.
    final p1 = Offset(
      centerX + xOffset1 + (mouseOffset.dx * 20) + (isSmallScreen ? 140 : 225),
      centerY + yOffset1 + (mouseOffset.dy * 20),
    );

    final xOffset2 = isSmallScreen ? 0.0 : 320.0;
    final yOffset2 = isSmallScreen ? 200.0 : 0.0;
    final p2 = Offset(
      centerX + xOffset2 + (mouseOffset.dx * -30) - (isSmallScreen ? 170 : 270),
      centerY + yOffset2 + (mouseOffset.dy * -30),
    );

    return Transform(
      // Rope at Z=80 (middle of 60 and 100) minimizes perspective drift
      transform: Matrix4.identity()..translate(0.0, 0.0, 80.0),
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return CustomPaint(
              size: Size(sceneWidth, sceneHeight),
              painter: _NeuralLinkPainter(
                p1: p1,
                p2: p2,
                color: AppTheme.primary,
                pulse: _pulseController.value,
              ),
            );
          },
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Certificate',
      barrierDismissible: true,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Stack(
              children: [
                InteractiveViewer(
                  child: Hero(
                    tag: 'certificateHero',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SvgPicture.asset(
                        'assets/completion_certificate_2025_svg.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        return FadeTransition(
            opacity: anim1, child: ScaleTransition(scale: anim1, child: child));
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  final double spacing;
  final Offset mousePos;

  _GridPainter(
      {required this.color, required this.spacing, required this.mousePos});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    for (double i = -spacing * 4; i <= size.width + spacing * 4; i += spacing) {
      // Perspective warping of grid lines based on mouse
      double xOffset = mousePos.dx * 20 * (i / size.width);
      canvas.drawLine(
        Offset(i + xOffset, -spacing * 2),
        Offset(i - xOffset, size.height + spacing * 2),
        paint,
      );
    }
    for (double i = -spacing * 4;
        i <= size.height + spacing * 4;
        i += spacing) {
      double yOffset = mousePos.dy * 20 * (i / size.height);
      canvas.drawLine(
        Offset(-spacing * 2, i + yOffset),
        Offset(size.width + spacing * 2, i - yOffset),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.mousePos != mousePos;
}

class _ScanlinePainter extends CustomPainter {
  final Color color;
  _ScanlinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.height; i += 4) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TechParticlePainter extends CustomPainter {
  final double progress;
  final Color color;

  _TechParticlePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.4);
    final random = math.Random(42);

    for (int i = 0; i < 50; i++) {
      double x = random.nextDouble() * size.width;
      double y =
          (random.nextDouble() * size.height + (progress * 100)) % size.height;
      double s = random.nextDouble() * 3 + 1;
      canvas.drawCircle(Offset(x, y), s, paint);

      if (random.nextDouble() > 0.8) {
        canvas.drawLine(
          Offset(x, y),
          Offset(x + 20, y + 20),
          paint..strokeWidth = 0.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _NeuralLinkPainter extends CustomPainter {
  final Offset p1;
  final Offset p2;
  final Color color;
  final double pulse;

  _NeuralLinkPainter(
      {required this.p1,
      required this.p2,
      required this.color,
      required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3 + (pulse * 0.2))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final energyPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(p1.dx, p1.dy);

    final double midX = (p1.dx + p2.dx) / 2;
    final double sag = 30.0 * math.sin(pulse * math.pi);

    path.cubicTo(
      midX,
      p1.dy + sag,
      midX,
      p2.dy - sag,
      p2.dx,
      p2.dy,
    );

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);

    // Animated energy bits
    final metrics = path.computeMetrics().first;
    for (int i = 0; i < 3; i++) {
      double t = (pulse + (i / 3.0)) % 1.0;
      final pos = metrics.getTangentForOffset(metrics.length * t)!.position;
      canvas.drawCircle(pos, 3 + (pulse * 2), energyPaint);
      canvas.drawCircle(
          pos, 8 + (pulse * 4), energyPaint..color = color.withOpacity(0.2));
    }

    // Nodes
    canvas.drawCircle(p1, 6 + (pulse * 2), Paint()..color = color);
    canvas.drawCircle(p2, 6 + (pulse * 2), Paint()..color = color);
    canvas.drawCircle(
        p1, 12, Paint()..color = color.withOpacity(0.1 * (1 - pulse)));
    canvas.drawCircle(
        p2, 12, Paint()..color = color.withOpacity(0.1 * (1 - pulse)));
  }

  @override
  bool shouldRepaint(covariant _NeuralLinkPainter oldDelegate) => true;
}
