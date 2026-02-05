import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border(
          top: BorderSide(
            color: AppTheme.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Iconic Dot Seperator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: AppTheme.primary, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.5),
                      shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: AppTheme.primary, shape: BoxShape.circle)),
            ],
          ),
          const SizedBox(height: 48),

          if (!isSmallScreen)
            _buildDesktopFooter(context)
          else
            _buildMobileFooter(context),

          const SizedBox(height: 60),

          _buildBottomCredits(context),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBrandSection(context),
        _buildSocialMini(context),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      children: [
        _buildBrandSection(context),
        const SizedBox(height: 40),
        _buildSocialMini(context),
      ],
    );
  }

  Widget _buildBrandSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: SvgPicture.asset('assets/favicon_svg.svg',
                  width: 22, height: 22),
            ),
            const SizedBox(width: 16),
            GradientText(
              text: 'AMIT MATTH',
              gradient: AppTheme.primaryGradient,
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        // Animated Tagline with Gradient Sweep Border
        const _AnimatedTagline(),
      ],
    );
  }

  Widget _buildSocialMini(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CoolSocialIcon(
          iconPath: 'assets/icons/instagram.svg',
          onTap: () => _launchURL('https://instagram.com/amit_matth'),
        ),
        _CoolSocialIcon(
          iconPath: 'assets/icons/discord.svg',
          onTap: () => _launchURL('https://discord.com/users/amit_matth'),
        ),
        _CoolSocialIcon(
          iconPath: 'assets/icons/x.svg',
          onTap: () => _launchURL('https://x.com/Amit_Matth'),
        ),
        _CoolSocialIcon(
          iconPath: 'assets/icons/gmail.svg',
          onTap: () => _launchURL('mailto:amitmatth121@gmail.com'),
        ),
        _CoolSocialIcon(
          iconPath: 'assets/icons/linkedin.svg',
          onTap: () => _launchURL('https://linkedin.com/in/amit-matth'),
        ),
      ],
    );
  }

  Widget _buildBottomCredits(BuildContext context) {
    return Column(
      children: [
        Text(
          '© 2026 AMIT MATTH. ALL RIGHTS RESERVED.',
          style: TextStyle(
            color: AppTheme.foreground.withOpacity(0.3),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt_rounded, color: AppTheme.primary, size: 14),
            const SizedBox(width: 4),
            Text(
              'MADE IN INDIA',
              style: TextStyle(
                color: AppTheme.foreground.withOpacity(0.4),
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnimatedTagline extends StatefulWidget {
  const _AnimatedTagline({Key? key}) : super(key: key);

  @override
  State<_AnimatedTagline> createState() => _AnimatedTaglineState();
}

class _AnimatedTaglineState extends State<_AnimatedTagline>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _SweepBorderPainter(animationValue: _controller.value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            child: GradientText(
              text: 'Building Apps , Breaking Limits',
              gradient: AppTheme.primaryGradient,
              style: GoogleFonts.syncopate(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SweepBorderPainter extends CustomPainter {
  final double animationValue;

  _SweepBorderPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(32));

    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          AppTheme.primary,
          AppTheme.primary.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 0.6, 1.0],
        transform: GradientRotation(animationValue * 2 * math.pi),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _SweepBorderPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class _CoolSocialIcon extends StatefulWidget {
  final String iconPath;
  final VoidCallback onTap;

  const _CoolSocialIcon({Key? key, required this.iconPath, required this.onTap})
      : super(key: key);

  @override
  State<_CoolSocialIcon> createState() => _CoolSocialIconState();
}

class _CoolSocialIconState extends State<_CoolSocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppTheme.primary.withOpacity(0.12)
                  : AppTheme.card.withOpacity(0.25),
              borderRadius: BorderRadius.circular(16),
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
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            transform: Matrix4.identity()
              ..translate(0.0, _isHovered ? -8.0 : 0.0, 0.0)
              ..scale(_isHovered ? 1.15 : 1.0),
            child: SvgPicture.asset(
              widget.iconPath,
              width: 22,
              height: 22,
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
