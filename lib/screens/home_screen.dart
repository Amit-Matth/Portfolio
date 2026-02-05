
import 'package:flutter/material.dart';
import '../widgets/particle_background.dart';
import '../sections/hero_section.dart';
import '../sections/navigation_header.dart';
import '../sections/skills_section.dart';
import '../sections/projects_section.dart';
import '../sections/experience_section.dart';
import '../sections/contact_section.dart';
import '../sections/footer_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey heroKey = GlobalKey();
  final GlobalKey skillsKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey experienceKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  final GlobalKey<ParticleBackgroundState> _particleKey = GlobalKey<ParticleBackgroundState>();

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(child: ParticleBackground(key: _particleKey)),

          CustomScrollView(
            controller: _scrollController,
            slivers: [
              NavigationHeader(
                onNavigate: scrollToSection,
                heroKey: heroKey,
                skillsKey: skillsKey,
                projectsKey: projectsKey,
                experienceKey: experienceKey,
                contactKey: contactKey,
              ),
              SliverToBoxAdapter(child: Container(key: heroKey, child: const HeroSection())),
              SliverToBoxAdapter(child: Container(key: experienceKey, child: const ExperienceSection())),
              SliverToBoxAdapter(child: Container(key: skillsKey, child: const SkillsSection())),
              SliverToBoxAdapter(child: Container(key: projectsKey, child: const ProjectsSection())),
              SliverToBoxAdapter(child: Container(key: contactKey, child: const ContactSection())),
              const SliverToBoxAdapter(child: FooterSection()),
            ],
          ),

          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (PointerDownEvent e) {
                final local = e.localPosition;
                _particleKey.currentState?.applyClickImpulse(local, strength: 12.0, maxRadius: 150.0);
                _particleKey.currentState?.setPointer(local);
              },
              onPointerMove: (PointerMoveEvent e) {
                _particleKey.currentState?.setPointer(e.localPosition);
              },
              onPointerUp: (PointerUpEvent e) {
                _particleKey.currentState?.clearPointer();
              },
              onPointerCancel: (PointerCancelEvent e) {
                _particleKey.currentState?.clearPointer();
              },
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}
