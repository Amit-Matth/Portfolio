import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry borderRadius; 
  final double blur;
  final double opacity;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool showGlow;
  final bool showStaticBorder;

  const GlassCard({
    Key? key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)), 
    this.blur = 5,
    this.opacity = 0.9,
    this.padding,
    this.margin,
    this.showGlow = true,
    this.showStaticBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: showGlow ? AppTheme.androidGlow : null, 
      child: ClipRRect(
        borderRadius: borderRadius, 
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: AppTheme.card.withOpacity(opacity),
              borderRadius: borderRadius, 
              border: showStaticBorder
                  ? Border.all(
                      color: AppTheme.border,
                      width: 2,
                    )
                  : null,
              boxShadow: showGlow ? [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ] : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
