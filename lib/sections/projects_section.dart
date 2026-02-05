import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({Key? key}) : super(key: key);

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with TickerProviderStateMixin {
  late AnimationController _pathController;
  late AnimationController _floatController;
  int? _hoveredIndex;
  Offset _mousePos = Offset.zero;

  late final List<GlobalKey> _timelineKeys;
  final GlobalKey _stackKey = GlobalKey();

  List<double> _nodeCenters = [];

  final List<ProjectNode> _projects = [
    ProjectNode(
      title: 'RISC-V DSP',
      subtitle: 'A Neural Network Library',
      description:
          'Built a library to run audio processing and basic AI on RISC-V chips. Optimized for speed and efficiency.',
      tags: ['C', 'RISC-V', 'DSP', 'ML', 'Spike', 'QEMU'],
      color: const Color(0xFFFF6B9D),
      icon: Icons.palette_rounded,
      detailsUrl: 'https://github.com/Amit-Matth/risc-v-dsp',
      year: '2026',
    ),
    ProjectNode(
      title: 'RISC-V Compliance',
      subtitle: 'Automation Suite',
      description:
          'Created a Python tool to automatically check if RISC-V processors are working correctly. Automated setup and testing.',
      tags: ['Python', 'RISC-V', 'Automation', 'Scripting'],
      color: const Color(0xFF4CAF50),
      icon: Icons.fact_check_rounded,
      detailsUrl: 'https://github.com/Amit-Matth/riscv_compliance_automation',
      year: '2026',
    ),
    ProjectNode(
      title: 'Paintroid Flutter',
      subtitle: 'GSoC 2025',
      description:
          'Improved Paintroid-Flutter by adding new tools (Text, Shapes, Color Picker) and simplifying the user experience.',
      tags: ['1M+ Downloads', 'Flutter', 'Dart', 'Open Source'],
      color: const Color(0xFF6750A4),
      icon: Icons.brush_rounded,
      detailsUrl: 'https://github.com/Catrobat/Paintroid-Flutter',
      contributionUrl:
          'https://gist.github.com/Amit-Matth/bf5981e2bd2237161c0e16f3e3e3959a#file-gsoc-2025-md',
      year: '2025',
    ),
    ProjectNode(
      title: 'Challenge Monitor',
      subtitle: 'Native Android',
      description:
          'Kotlin-based Android app for tracking personal challenges with daily progress monitoring and SQLite storage.',
      tags: ['Kotlin', 'SQLite', 'Productivity'],
      color: const Color(0xFF00D9FF),
      logoPath: 'assets/challenge_monitor_logo.png',
      detailsUrl: 'https://github.com/Amit-Matth/ChallengeMonitor',
      downloadUrl:
          'https://github.com/Amit-Matth/Challenge-Monitor/releases/download/v1.0.0/Challenge-Monitor-universal-v1.0.0.apk',
      year: '2025',
    ),
    ProjectNode(
      title: 'IQ Booster',
      subtitle: 'Native Android',
      description:
          'Brain training games with Firebase integration, Google Sign-In, and modern Material Design.',
      tags: ['Java', 'Firebase', 'XML', 'Published'],
      color: AppTheme.accent,
      logoPath: 'assets/iq_booster_logo.png',
      detailsUrl: 'https://github.com/Amit-Matth/IQBooster',
      downloadUrl:
          'https://github.com/Amit-Matth/IQ-Booster/releases/download/v1.0.0/IQ-Booster-universal-v1.0.0.apk',
      year: '2025',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _timelineKeys = List.generate(_projects.length, (_) => GlobalKey());

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateNodePositions());
  }

  @override
  void dispose() {
    _pathController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _updateNodePositions() {
    final stackContext = _stackKey.currentContext;
    if (stackContext == null) return;
    final stackBox = stackContext.findRenderObject() as RenderBox;
    final stackTopLeftGlobal = stackBox.localToGlobal(Offset.zero);

    final centers = <double>[];
    for (var key in _timelineKeys) {
      final ctx = key.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox;
      final topLeftGlobal = box.localToGlobal(Offset.zero);
      final topLeftRelative = topLeftGlobal - stackTopLeftGlobal;
      final centerY = topLeftRelative.dy + box.size.height / 2;
      centers.add(centerY);
    }

    if (mounted) {
      setState(() {
        _nodeCenters = centers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 768;
    final size = MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateNodePositions());

    return MouseRegion(
      onHover: (event) {
        setState(() {
          _mousePos = Offset(
            (event.localPosition.dx - (size.width / 2)) / (size.width / 2),
            (event.localPosition.dy - (size.height / 2)) / (size.height / 2),
          );
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
        child: Column(
          children: [
            _buildHeader(isSmallScreen),
            const SizedBox(height: 100),
            _buildProjectList(context, isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Column(
      children: [
        GradientText(
          text: 'Project Journey',
          gradient: AppTheme.primaryGradient,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: isSmallScreen ? 36 : 56,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 4,
          width: 100,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectList(BuildContext context, bool isSmallScreen) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isSmallScreen ? 600 : 1100),
        child: Stack(
          key: _stackKey,
          children: [
            // Background Animation (Stream of connections)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _pathController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _3DRoadmapPainter(
                      animation: _pathController,
                      nodeCenters: _nodeCenters,
                      isSmallScreen: isSmallScreen,
                      hoveredIndex: _hoveredIndex,
                    ),
                  );
                },
              ),
            ),

            Column(
              children: List.generate(_projects.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: _buildProjectRow(index, isSmallScreen),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectRow(int index, bool isSmallScreen) {
    final project = _projects[index];
    final isLeft = index % 2 == 0;

    if (isSmallScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            key: _timelineKeys[index],
            width: 40,
            child: _buildTimelineNode(project.color, index),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _build3DCard(project, index, isSmallScreen, true),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: isLeft
              ? _build3DCard(project, index, isSmallScreen, true)
              : const SizedBox(),
        ),
        SizedBox(
          key: _timelineKeys[index],
          width: 120,
          child: _buildTimelineNode(project.color, index),
        ),
        Expanded(
          child: !isLeft
              ? _build3DCard(project, index, isSmallScreen, false)
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildTimelineNode(Color color, int index) {
    final isHovered = _hoveredIndex == index;
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isHovered ? 40 : 24,
        height: isHovered ? 40 : 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: isHovered ? 4 : 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: isHovered ? 20 : 10,
              spreadRadius: isHovered ? 4 : 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _build3DCard(
      ProjectNode project, int index, bool isSmallScreen, bool isLeft) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final floatOffset =
              math.sin(_floatController.value * 2 * math.pi) * 8.0;

          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            tween: Tween(begin: 0, end: isHovered ? 1.0 : 0.0),
            curve: Curves.easeOutCubic,
            builder: (context, hoverVal, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(0.0, floatOffset, 0.0)
                  ..rotateY(_mousePos.dx * 0.15 * hoverVal)
                  ..rotateX(-_mousePos.dy * 0.15 * hoverVal)
                  ..scale(1.0 + (0.05 * hoverVal)),
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color:
                            project.color.withOpacity(0.15 * hoverVal + 0.05),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppTheme.card.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: project.color
                                .withOpacity(0.2 + (0.4 * hoverVal)),
                            width: 1.5,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              project.color.withOpacity(0.1),
                              Colors.transparent,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCardHeader(project),
                            const SizedBox(height: 20),
                            Text(
                              project.description,
                              style: TextStyle(
                                color: AppTheme.foreground.withOpacity(0.8),
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildTags(project.tags, project.color),
                            const SizedBox(height: 32),
                            _buildActionButtons(project),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCardHeader(ProjectNode project) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: project.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: project.color.withOpacity(0.3)),
          ),
          child: project.icon != null
              ? Icon(project.icon, color: project.color, size: 28)
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    project.logoPath!,
                    color: project.logoTintColor ?? project.color,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.apps, color: project.color),
                  ),
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                style: TextStyle(
                  color: project.color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                project.subtitle,
                style: TextStyle(
                  color: AppTheme.foreground.withOpacity(0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Text(
          project.year,
          style: TextStyle(
            color: project.color.withOpacity(0.5),
            fontSize: 18,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildTags(List<String> tags, Color color) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map((tag) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                      color: color, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildActionButtons(ProjectNode project) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _launchURL(project.detailsUrl),
            icon: const Icon(Icons.code_rounded, size: 18),
            label: const Text('GITHUB'),
            style: ElevatedButton.styleFrom(
              backgroundColor: project.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (project.downloadUrl != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _launchURL(project.downloadUrl!),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('DOWNLOAD'),
              style: OutlinedButton.styleFrom(
                foregroundColor: project.color,
                side: BorderSide(color: project.color, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        if (project.contributionUrl != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: OutlinedButton.icon(
                onPressed: () => _launchURL(project.contributionUrl!),
                icon: const Icon(Icons.description_rounded, size: 18),
                label: const Text('MY WORK'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: project.color,
                  side: BorderSide(color: project.color, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw 'Could not launch $url';
  }
}

class _3DRoadmapPainter extends CustomPainter {
  final Animation<double> animation;
  final List<double> nodeCenters;
  final bool isSmallScreen;
  final int? hoveredIndex;

  _3DRoadmapPainter({
    required this.animation,
    required this.nodeCenters,
    required this.isSmallScreen,
    this.hoveredIndex,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCenters.isEmpty) return;

    final double timelineX = isSmallScreen ? 20 : size.width / 2;
    final paint = Paint()
      ..color = AppTheme.primary.withOpacity(0.15)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < nodeCenters.length - 1; i++) {
      final startY = nodeCenters[i];
      final endY = nodeCenters[i + 1];

      final path = Path()..moveTo(timelineX, startY);

      if (isSmallScreen) {
        path.lineTo(timelineX, endY);
      } else {
        final controlX = i % 2 == 0 ? timelineX + 100 : timelineX - 100;
        path.cubicTo(
          timelineX,
          startY + (endY - startY) / 3,
          controlX,
          startY + (endY - startY) / 2,
          timelineX,
          endY,
        );
      }

      // Base path
      canvas.drawPath(path, paint);

      // Animated "Energy Stream"
      final pathMetrics = path.computeMetrics();
      for (var metric in pathMetrics) {
        final length = metric.length;
        final start = (animation.value * length) % length;
        final end = (start + 100) % length;

        if (start < end) {
          canvas.drawPath(
            metric.extractPath(start, end),
            glowPaint
              ..shader = LinearGradient(
                colors: [
                  Colors.transparent,
                  AppTheme.primary.withOpacity(0.6),
                  Colors.transparent
                ],
              ).createShader(
                  Rect.fromLTWH(0, startY, size.width, endY - startY)),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _3DRoadmapPainter oldDelegate) => true;
}

class ProjectNode {
  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;
  final Color color;
  final String? logoPath;
  final IconData? icon;
  final Color? logoTintColor;
  final String detailsUrl;
  final String? downloadUrl;
  final String? contributionUrl;
  final String year;

  ProjectNode({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
    required this.color,
    this.logoPath,
    this.icon,
    this.logoTintColor,
    required this.detailsUrl,
    this.downloadUrl,
    this.contributionUrl,
    required this.year,
  });
}
