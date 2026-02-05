import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';

class NavigationHeader extends StatefulWidget {
  final Function(GlobalKey) onNavigate;
  final GlobalKey heroKey;
  final GlobalKey skillsKey;
  final GlobalKey projectsKey;
  final GlobalKey experienceKey;
  final GlobalKey contactKey;

  const NavigationHeader({
    Key? key,
    required this.onNavigate,
    required this.heroKey,
    required this.skillsKey,
    required this.projectsKey,
    required this.experienceKey,
    required this.contactKey,
  }) : super(key: key);

  @override
  State<NavigationHeader> createState() => _NavigationHeaderState();
}

class _NavigationHeaderState extends State<NavigationHeader> {
  bool _isLogoHovered = false;
  String? _hoveredItem;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 768;

    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      toolbarHeight: 90,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.background.withOpacity(0.75),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.primary.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLogo(context, isSmallScreen),
                    if (!isSmallScreen)
                      _buildDesktopNav()
                    else
                      _buildMobileNavTrigger(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, bool isSmallScreen) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isLogoHovered = true),
      onExit: (_) => setState(() => _isLogoHovered = false),
      child: GestureDetector(
        onTap: () => widget.onNavigate(widget.heroKey),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isLogoHovered
                ? AppTheme.primary.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isLogoHovered
                  ? AppTheme.primary.withOpacity(0.2)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedRotation(
                turns: _isLogoHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primary.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: SvgPicture.asset('assets/favicon_svg.svg',
                      width: 24, height: 24),
                ),
              ),
              const SizedBox(width: 16),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 400),
                tween: Tween(begin: 0, end: _isLogoHovered ? 1.0 : 0.0),
                builder: (context, val, child) {
                  return GradientText(
                    text: 'AMIT MATTH',
                    gradient: AppTheme.primaryGradient,
                    style: GoogleFonts.syncopate(
                      fontSize: isSmallScreen ? 16 : 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: isSmallScreen ? 1 : (2 + (6 * val)),
                      shadows: val > 0
                          ? [
                              Shadow(
                                color: AppTheme.primary.withOpacity(0.4 * val),
                                blurRadius: 10 * val,
                              ),
                            ]
                          : [],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopNav() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNavItem('SKILLS', widget.skillsKey),
          _buildNavItem('PROJECTS', widget.projectsKey),
          _buildNavItem('EXPERIENCE', widget.experienceKey),
          _buildNavItem('CONTACT', widget.contactKey),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, GlobalKey target) {
    final isHovered = _hoveredItem == title;
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredItem = title),
      onExit: (_) => setState(() => _hoveredItem = null),
      child: GestureDetector(
        onTap: () => widget.onNavigate(target),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: isHovered ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.5),
                      blurRadius: 15,
                    )
                  ]
                : [],
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isHovered
                  ? Colors.black
                  : AppTheme.foreground.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNavTrigger() {
    return PopupMenuButton<GlobalKey>(
      icon: const Icon(Icons.menu_rounded, color: AppTheme.primary, size: 32),
      offset: const Offset(0, 50),
      color: AppTheme.card.withOpacity(0.95),
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: AppTheme.primary.withOpacity(0.5), width: 1.5),
      ),
      onSelected: (key) => widget.onNavigate(key),
      itemBuilder: (context) => [
        _buildPopupItem('SKILLS', widget.skillsKey, Icons.bolt_rounded),
        _buildPopupItem(
            'PROJECTS', widget.projectsKey, Icons.rocket_launch_rounded),
        _buildPopupItem('EXPERIENCE', widget.experienceKey,
            Icons.workspace_premium_rounded),
        _buildPopupItem('CONTACT', widget.contactKey, Icons.terminal_rounded),
      ],
    );
  }

  PopupMenuItem<GlobalKey> _buildPopupItem(
      String title, GlobalKey key, IconData icon) {
    return PopupMenuItem(
      value: key,
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(width: 14),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.foreground,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
