import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({Key? key}) : super(key: key);

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  double _dx = 0;
  double _dy = 0;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 768;

    return MouseRegion(
      onHover: (event) {
        setState(() {
          _isHovering = true;
          _dx = (event.localPosition.dx - (size.width / 2)) / (size.width / 2);
          _dy =
              (event.localPosition.dy - (size.height / 2)) / (size.height / 2);
        });
      },
      onExit: (_) => setState(() {
        _isHovering = false;
        _dx = 0;
        _dy = 0;
      }),
      child: Container(
        height: isSmallScreen ? null : size.height,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 60,
          horizontal: isSmallScreen ? 20 : 80, // Consistent with other sections
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Decorative Elements
            _buildBackgroundGrid(),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: isSmallScreen
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildProfileAvatar(true),
                        const SizedBox(height: 60),
                        _buildTextContent(true),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(flex: 6, child: _buildTextContent(false)),
                        const SizedBox(width: 40),
                        Expanded(
                            flex: 4,
                            child: Center(child: _buildProfileAvatar(false))),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGrid() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _HeroGridPainter(dx: _dx, dy: _dy, isHovering: _isHovering),
      ),
    );
  }

  Widget _buildProfileAvatar(bool isSmallScreen) {
    final avatarSize = isSmallScreen ? 240.0 : 380.0; // Optimized size

    return TweenAnimationBuilder<double>(
      duration:
          const Duration(milliseconds: 200), // Faster response for tracking
      tween: Tween(begin: 0, end: _isHovering ? 1.0 : 0.0),
      builder: (context, val, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(_dx * 20 * val,
                _dy * 20 * val) // Subtle movement towards cursor
            ..rotateY(_dx * 0.18 * val)
            ..rotateX(-_dy * 0.18 * val),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glow
              Container(
                width: avatarSize + 60,
                height: avatarSize + 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary
                      .withOpacity(0.02 * val), // Added subtle center glow
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.12 * val + 0.08),
                      blurRadius: 70,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
              // Floating Orbit Rings
              _buildOrbitRing(avatarSize * 1.35, 0.5, val),
              _buildOrbitRing(avatarSize * 1.6, -0.3, val),

              // Main Image Container
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.card, // Ensure image has a solid background
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.25 + (0.35 * val)),
                    width: 2.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      6), // Less padding to prevent image cutting
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile_img.jpg',
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
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

  Widget _buildOrbitRing(double size, double rotation, double hoverVal) {
    return Transform.rotate(
      angle: rotation + (_dx * 0.2 * hoverVal),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.1 * hoverVal + 0.05),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(bool isSmallScreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          isSmallScreen ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Intro Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt_rounded, color: AppTheme.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                'WELCOME TO MY UNIVERSE',
                style: GoogleFonts.rajdhani(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Main Name
        FittedBox(
          fit: BoxFit.scaleDown,
          child: GradientText(
            text: "AMIT MATTH",
            gradient: AppTheme.primaryGradient,
            style: GoogleFonts.orbitron(
              fontSize: isSmallScreen ? 48 : 82,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Animated Tagline
        SizedBox(
          height: isSmallScreen ? 80 : 48,
          child: DefaultTextStyle(
            style: GoogleFonts.rajdhani(
              fontSize: isSmallScreen ? 24 : 32,
              fontWeight: FontWeight.w800,
              color: AppTheme.foreground.withOpacity(0.9),
              letterSpacing: 1.5,
            ),
            maxLines: 2,
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                TypewriterAnimatedText(
                    'Application Developer & System Engineer'),
                TypewriterAnimatedText('Building Apps , Breaking Limits'),
                TypewriterAnimatedText('GSoC 2025 Contributor'),
                TypewriterAnimatedText('RISC-V Enthusiast'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Body Description
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            'Bridging the gap between high-level mobile applications and low-level system engineering. Building efficient, scalable software for the future.',
            style: TextStyle(
              color: AppTheme.foreground.withOpacity(0.6),
              fontSize: 18,
              height: 1.6,
            ),
            textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
          ),
        ),

        const SizedBox(height: 60),

        // Action Buttons
        _buildActionButtons(isSmallScreen),
      ],
    );
  }

  Widget _buildActionButtons(bool isSmallScreen) {
    return Column(
      crossAxisAlignment:
          isSmallScreen ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _buildSocialMini(context),
      ],
    );
  }

  Widget _buildSocialMini(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMiniSocialIcon(
            'assets/icons/instagram.svg', 'https://instagram.com/amit_matth'),
        _buildMiniSocialIcon(
            'assets/icons/discord.svg', 'https://discord.com/users/amit_matth'),
        _buildMiniSocialIcon('assets/icons/x.svg', 'https://x.com/Amit_Matth'),
        _buildMiniSocialIcon(
            'assets/icons/gmail.svg', 'mailto:amitmatth121@gmail.com'),
        _buildMiniSocialIcon(
            'assets/icons/linkedin.svg', 'https://linkedin.com/in/amit-matth'),
      ],
    );
  }

  Widget _buildMiniSocialIcon(String iconPath, String url) {
    return _CoolSocialIconMini(
      iconPath: iconPath,
      onTap: () => _launchURL(url),
    );
  }
}

class _CoolSocialIconMini extends StatefulWidget {
  final String iconPath;
  final VoidCallback onTap;

  const _CoolSocialIconMini(
      {Key? key, required this.iconPath, required this.onTap})
      : super(key: key);

  @override
  State<_CoolSocialIconMini> createState() => _CoolSocialIconMiniState();
}

class _CoolSocialIconMiniState extends State<_CoolSocialIconMini> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppTheme.primary.withOpacity(0.12)
                  : AppTheme.card.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered
                    ? AppTheme.primary
                    : AppTheme.primary.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
            transform: Matrix4.identity()
              ..translate(0.0, _isHovered ? -5.0 : 0.0, 0.0)
              ..scale(_isHovered ? 1.1 : 1.0),
            child: SvgPicture.asset(
              widget.iconPath,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                _isHovered ? Colors.white : AppTheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroGridPainter extends CustomPainter {
  final double dx;
  final double dy;
  final bool isHovering;

  _HeroGridPainter(
      {required this.dx, required this.dy, required this.isHovering});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary.withOpacity(0.05)
      ..strokeWidth = 1;

    const spacing = 100.0;

    for (double i = 0; i < size.width; i += spacing) {
      final xOffset = dx * 10;
      canvas.drawLine(
          Offset(i + xOffset, 0), Offset(i + xOffset, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      final yOffset = dy * 10;
      canvas.drawLine(
          Offset(0, i + yOffset), Offset(size.width, i + yOffset), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeroGridPainter oldDelegate) =>
      oldDelegate.dx != dx ||
      oldDelegate.dy != dy ||
      oldDelegate.isHovering != isHovering;
}
