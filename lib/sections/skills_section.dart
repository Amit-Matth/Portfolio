import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({Key? key}) : super(key: key);

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  int _selectedIndex = 0;
  int? _hoveredIndex;

  final List<String> _categories = [
    'Languages',
    'Mobile',
    'Systems',
    'Backend & Tools',
  ];

  final Map<String, List<SkillItem>> _skillsMap = {
    'Languages': [
      SkillItem('C', iconData: Icons.code),
      SkillItem('C++', iconData: Icons.integration_instructions),
      SkillItem('Python', iconData: Icons.terminal),
      SkillItem('Java', iconPath: 'assets/icons/java.svg'),
    ],
    'Mobile': [
      SkillItem('Android', iconPath: 'assets/icons/android_native.svg'),
      SkillItem('Flutter', iconPath: 'assets/icons/flutter.svg'),
      SkillItem('Kotlin', iconPath: 'assets/icons/kotlin.svg'),
      SkillItem('Dart', iconPath: 'assets/icons/dart.svg'),
      SkillItem('Compose', iconPath: 'assets/icons/jetpackcompose.svg'),
      SkillItem('Material', iconPath: 'assets/icons/material_design.svg'),
      SkillItem('XML', iconPath: 'assets/icons/xml.svg'),
    ],
    'Systems': [
      SkillItem('RISC-V', iconData: Icons.memory),
      SkillItem('Embedded', iconData: Icons.settings_input_component),
      SkillItem('Linux', iconData: Icons.laptop_chromebook),
      SkillItem('Make', iconData: Icons.build),
      SkillItem('GDB', iconData: Icons.bug_report),
    ],
    'Backend & Tools': [
      SkillItem('Firebase', iconPath: 'assets/icons/firebase_rtdb.svg'),
      SkillItem('SQLite', iconPath: 'assets/icons/sqlite.svg'),
      SkillItem('Room', iconPath: 'assets/icons/database.svg'),
      SkillItem('Git', iconPath: 'assets/icons/github.svg'),
      SkillItem('JUnit', iconPath: 'assets/icons/junit.svg'),
      SkillItem('Mockito', iconPath: 'assets/icons/mockito.svg'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 768;
    final currentSkills = _skillsMap[_categories[_selectedIndex]]!;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isSmallScreen ? 24 : 0,
      ),
      child: Column(
        children: [
          GradientText(
            text: 'Technical Arsenal',
            gradient: AppTheme.primaryGradient,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: isSmallScreen ? 36 : 48,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          _buildCategoryTabs(isSmallScreen),
          const SizedBox(height: 60),
          _buildSkillsGrid(currentSkills, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.card.withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: isSmallScreen
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_categories.length, (index) {
                  return _buildTabItem(index);
                }),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_categories.length, (index) {
                return _buildTabItem(index);
              }),
            ),
    );
  }

  Widget _buildTabItem(int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.4),
                    blurRadius: 10,
                  )
                ]
              : [],
        ),
        child: Text(
          _categories[index],
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : AppTheme.foreground.withOpacity(0.6),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsGrid(List<SkillItem> skills, bool isSmallScreen) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Center(
        key: ValueKey<int>(_selectedIndex),
        child: Container(
          width: 1000,
          alignment: Alignment.center,
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: List.generate(skills.length, (index) {
              return _buildSkillCard(skills[index], index, isSmallScreen);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillCard(SkillItem skill, int index, bool isSmallScreen) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSmallScreen ? 140 : 160,
        height: isSmallScreen ? 140 : 160,
        transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),
        decoration: BoxDecoration(
          color: AppTheme.card.withOpacity(isHovered ? 0.8 : 0.4),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered
                ? AppTheme.primary.withOpacity(0.5)
                : AppTheme.primary.withOpacity(0.1),
            width: isHovered ? 2 : 1,
          ),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(skill, isSmallScreen, isHovered),
                const SizedBox(height: 16),
                Text(
                  skill.name,
                  style: TextStyle(
                    color: AppTheme.foreground.withOpacity(isHovered ? 1 : 0.8),
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(SkillItem skill, bool isSmallScreen, bool isHovered) {
    final size = isSmallScreen ? 40.0 : 48.0;

    if (skill.iconData != null) {
      return Icon(
        skill.iconData,
        size: size,
        color:
            isHovered ? AppTheme.primary : AppTheme.foreground.withOpacity(0.7),
      );
    } else if (skill.iconPath != null) {
      return SvgPicture.asset(
        skill.iconPath!,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(
          isHovered ? AppTheme.primary : AppTheme.foreground.withOpacity(0.7),
          BlendMode.srcIn,
        ),
      );
    }
    return SizedBox(width: size, height: size);
  }
}

class SkillItem {
  final String name;
  final String? iconPath;
  final IconData? iconData;

  SkillItem(this.name, {this.iconPath, this.iconData});
}
