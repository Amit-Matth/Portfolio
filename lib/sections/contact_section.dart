import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Offset _mousePos = Offset.zero;
  bool _isHovering = false;

  final List<ContactBlock> _contactBlocks = [
    ContactBlock(
      title: 'Instagram',
      icon: 'assets/icons/instagram.svg',
      color: const Color(0xFFE1306C),
      url: 'https://instagram.com/amit_matth',
      description: '@amit_matth',
    ),
    ContactBlock(
      title: 'Discord',
      icon: 'assets/icons/discord.svg',
      color: const Color(0xFF5865F2),
      url: 'https://discord.com/users/amit_matth',
      description: 'amit_matth',
    ),
    ContactBlock(
      title: 'X',
      icon: 'assets/icons/x.svg',
      color: const Color(0xFF000000),
      url: 'https://x.com/Amit_Matth',
      description: '@Amit_Matth',
    ),
    ContactBlock(
      title: 'Email',
      icon: 'assets/icons/gmail.svg',
      color: const Color(0xFFEA4335),
      url: 'mailto:amitmatth121@gmail.com',
      description: 'amitmatth121@gmail.com',
    ),
    ContactBlock(
      title: 'LinkedIn',
      icon: 'assets/icons/linkedin.svg',
      color: const Color(0xFF0A66C2),
      url: 'https://linkedin.com/in/amit-matth',
      description: 'Professional Profile',
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 768;
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 60 : 120,
        horizontal: 24,
      ),
      child: MouseRegion(
        onHover: (event) {
          setState(() {
            _mousePos = Offset(
              (event.localPosition.dx - (size.width / 2)) / (size.width / 2),
              (event.localPosition.dy - (size.height / 2)) / (size.height / 2),
            );
          });
        },
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() {
          _isHovering = false;
          _mousePos = Offset.zero;
        }),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                _buildHeader(isSmallScreen),
                const SizedBox(height: 80),
                _buildMainContent(context, isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Column(
      children: [
        GradientText(
          text: 'CONNECT WITH ME',
          gradient: AppTheme.primaryGradient,
          style: GoogleFonts.orbitron(
            fontSize: isSmallScreen ? 32 : 48,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          height: 2,
          width: 60,
          color: AppTheme.primary.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context, bool isSmallScreen) {
    if (isSmallScreen) {
      return Column(
        children: [
          _buildSocialGrid(true),
          const SizedBox(height: 60),
          _build3DContactForm(context, true),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: _buildSocialGrid(false),
        ),
        const SizedBox(width: 60),
        Expanded(
          flex: 1,
          child: Center(child: _build3DContactForm(context, false)),
        ),
      ],
    );
  }

  Widget _buildSocialGrid(bool isSmallScreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _contactBlocks
          .map((block) => Center(
                child: SizedBox(
                  width: isSmallScreen ? double.infinity : 480,
                  child: _buildContactCard(block, isSmallScreen),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildContactCard(ContactBlock block, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0, end: _isHovering ? 1.0 : 0.0),
        builder: (context, val, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(_mousePos.dx * 20 * val, _mousePos.dy * 20 * val)
              ..rotateY(_mousePos.dx * 0.1 * val),
            child: InkWell(
              onTap: () => _launchURL(block.url),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.card.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: block.color.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: block.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SvgPicture.asset(
                        block.icon,
                        width: 24,
                        height: 24,
                        colorFilter:
                            ColorFilter.mode(block.color, BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            block.title,
                            style: const TextStyle(
                                color: AppTheme.foreground,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            block.description,
                            style: TextStyle(
                                color: AppTheme.foreground.withOpacity(0.5),
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _build3DContactForm(BuildContext context, bool isSmallScreen) {
    final formWidth = isSmallScreen ? double.infinity : 480.0;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0, end: _isHovering ? 1.0 : 0.0),
      builder: (context, val, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(_mousePos.dx * -40 * val, _mousePos.dy * -30 * val)
            ..rotateY(_mousePos.dx * -0.05 * val),
          child: Container(
            width: formWidth,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppTheme.card.withOpacity(0.7),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.1),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'LEAVE A MESSAGE',
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSlimTextField(
                    controller: _nameController,
                    label: 'NAME',
                    icon: Icons.person_outline,
                    validator: (v) => v!.isEmpty ? '?' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildSlimTextField(
                    controller: _emailController,
                    label: 'EMAIL',
                    icon: Icons.alternate_email,
                    validator: (v) => !v!.contains('@') ? '?' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildSlimTextField(
                    controller: _messageController,
                    label: 'MESSAGE',
                    icon: Icons.chat_bubble_outline,
                    maxLines: 3,
                    validator: (v) => v!.isEmpty ? '?' : null,
                  ),
                  const SizedBox(height: 32),
                  _buildModernSubmit(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSlimTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: AppTheme.primary.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(color: AppTheme.foreground, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon:
                Icon(icon, color: AppTheme.primary.withOpacity(0.4), size: 18),
            filled: true,
            fillColor: Colors.black.withOpacity(0.2),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppTheme.border.withOpacity(0.15)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildModernSubmit() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: AppTheme.primaryGradient,
      ),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('SEND NOW',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('messages').add({
          'name': _nameController.text,
          'email': _emailController.text,
          'message': _messageController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sent! 🚀')));
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

class ContactBlock {
  final String title;
  final String description;
  final String icon;
  final Color color;
  final String url;
  ContactBlock(
      {required this.title,
      required this.description,
      required this.icon,
      required this.color,
      required this.url});
}
