import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

extension OffsetExtension on Offset {
  Offset normalize() {
    final d = distance;
    if (d == 0) return Offset.zero;
    return this / d;
  }
}

class Particle {
  final String id;
  final IconData icon;
  final Color color;
  final double phase;
  final double radius = 30.0;
  final Random _random = Random();

  Offset position;
  Offset velocity;

  Particle({
    required this.id,
    required Offset initialPosition,
    required this.icon,
    required this.color,
    required this.phase,
  })  : position = initialPosition,
        velocity = Offset.zero;

  void initializeVelocity() {
    double angle = _random.nextDouble() * 2 * pi;
    double speed = 0.5 + _random.nextDouble() * 1.0;
    velocity = Offset(cos(angle), sin(angle)) * speed;
  }

  void update(Offset pointerPosition, Size size, List<Particle> allParticles) {
    position += velocity;

    if (position.dx <= radius || position.dx >= size.width - radius) {
      velocity = Offset(-velocity.dx, velocity.dy);
      position =
          Offset(position.dx.clamp(radius, size.width - radius), position.dy);
    }
    if (position.dy <= radius || position.dy >= size.height - radius) {
      velocity = Offset(velocity.dx, -velocity.dy);
      position =
          Offset(position.dx, position.dy.clamp(radius, size.height - radius));
    }

    for (var other in allParticles) {
      if (other.id == id) continue;
      final delta = position - other.position;
      final dist = delta.distance;
      final minDist = radius + other.radius;
      if (dist < minDist && dist > 0) {
        final normal = delta.normalize();
        final overlap = minDist - dist;
        position += normal * (overlap / 2);
        other.position -= normal * (overlap / 2);

        final relativeVelocity = (velocity - other.velocity).dx * normal.dx +
            (velocity - other.velocity).dy * normal.dy;
        if (relativeVelocity < 0) {
          final impulse = normal * relativeVelocity;
          velocity -= impulse;
          other.velocity += impulse;

          double randomAngle = (_random.nextDouble() - 0.5) * 0.3;
          velocity = _rotateVector(velocity, randomAngle);
          other.velocity = _rotateVector(other.velocity, randomAngle);
        }
      }
    }

    if (pointerPosition != Offset.zero) {
      double distToPointer = (position - pointerPosition).distance;
      double repulsionRadius = 300.0;
      if (distToPointer > 0 && distToPointer < repulsionRadius) {
        final repulsionVector = (position - pointerPosition).normalize();
        final repulsionStrength =
            (1 - (distToPointer / repulsionRadius)) * 16.0;
        velocity += repulsionVector * repulsionStrength;

        double speed = velocity.distance;
        if (speed > 8.0) velocity = velocity.normalize() * 8.0;
      }
    }

    velocity *= 0.98;
    double speed = velocity.distance;
    if (speed < 0.5 && speed > 0.0) {
      velocity = velocity.normalize() * 0.5;
    } else if (speed == 0.0) {
      double angle = _random.nextDouble() * 2 * pi;
      velocity = Offset(cos(angle), sin(angle)) * 0.5;
    }
  }

  Offset _rotateVector(Offset vector, double angle) {
    double cosA = cos(angle);
    double sinA = sin(angle);
    return Offset(vector.dx * cosA - vector.dy * sinA,
        vector.dx * sinA + vector.dy * cosA);
  }
}

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({Key? key}) : super(key: key);

  @override
  ParticleBackgroundState createState() => ParticleBackgroundState();
}

class ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleMoveController;
  late AnimationController _glowController;
  Offset _pointerPosition = Offset.zero;
  List<Particle> _particles = [];
  Size _size = Size.zero;
  bool _initialized = false;

  final List<Map<String, dynamic>> _initialNodes = [
    {
      "id": "android",
      "pos": Offset(0.1, 0.1),
      "icon": Icons.android,
      "color": Colors.greenAccent
    },
    {
      "id": "apple",
      "pos": Offset(0.9, 0.1),
      "icon": Icons.apple,
      "color": Colors.white
    },
    {
      "id": "web",
      "pos": Offset(0.1, 0.9),
      "icon": Icons.web,
      "color": Colors.purpleAccent
    },
    {
      "id": "cloud",
      "pos": Offset(0.9, 0.9),
      "icon": Icons.cloud,
      "color": Colors.blueAccent
    },
    {
      "id": "database",
      "pos": Offset(0.25, 0.5),
      "icon": Icons.storage,
      "color": Colors.amber
    },
    {
      "id": "api",
      "pos": Offset(0.75, 0.5),
      "icon": Icons.api,
      "color": Colors.lightGreenAccent
    },
    {
      "id": "security",
      "pos": Offset(0.7, 0.75),
      "icon": Icons.security,
      "color": Colors.redAccent
    },
    {
      "id": "network",
      "pos": Offset(0.3, 0.25),
      "icon": Icons.wifi,
      "color": Colors.indigoAccent
    },
    {
      "id": "jetpack",
      "pos": Offset(0.45, 0.15),
      "icon": Icons.widgets,
      "color": Colors.tealAccent
    },
    {
      "id": "kotlin",
      "pos": Offset(0.55, 0.2),
      "icon": Icons.code,
      "color": Colors.deepOrangeAccent
    },
    {
      "id": "playstore",
      "pos": Offset(0.8, 0.25),
      "icon": Icons.shop,
      "color": Colors.lightBlueAccent
    },
    {
      "id": "firebase",
      "pos": Offset(0.5, 0.75),
      "icon": Icons.fireplace,
      "color": Colors.orangeAccent
    },
    {
      "id": "sensors",
      "pos": Offset(0.35, 0.65),
      "icon": Icons.sensors,
      "color": Colors.cyanAccent
    },
    {
      "id": "uiux",
      "pos": Offset(0.6, 0.35),
      "icon": Icons.design_services,
      "color": Colors.pinkAccent
    },
    {
      "id": "testing",
      "pos": Offset(0.45, 0.9),
      "icon": Icons.bug_report,
      "color": Colors.limeAccent
    },
    {
      "id": "performance",
      "pos": Offset(0.55, 0.55),
      "icon": Icons.speed,
      "color": Colors.lightBlueAccent
    },
    {
      "id": "analytics",
      "pos": Offset(0.2, 0.7),
      "icon": Icons.analytics,
      "color": Colors.deepPurpleAccent
    },
    {
      "id": "notifications",
      "pos": Offset(0.8, 0.5),
      "icon": Icons.notifications,
      "color": Colors.yellowAccent
    },
    {
      "id": "ci_cd",
      "pos": Offset(0.6, 0.65),
      "icon": Icons.autorenew,
      "color": Colors.teal
    },
    {
      "id": "maps",
      "pos": Offset(0.35, 0.35),
      "icon": Icons.map,
      "color": Colors.green
    },
    {
      "id": "ml",
      "pos": Offset(0.65, 0.2),
      "icon": Icons.memory,
      "color": Colors.orange
    },
    {
      "id": "ar_vr",
      "pos": Offset(0.75, 0.8),
      "icon": Icons.vrpano,
      "color": Colors.pinkAccent
    },
    {
      "id": "payments",
      "pos": Offset(0.5, 0.25),
      "icon": Icons.payment,
      "color": Colors.blueGrey
    },
    {
      "id": "chat",
      "pos": Offset(0.25, 0.8),
      "icon": Icons.chat,
      "color": Colors.lightGreen
    },
    {
      "id": "iot",
      "pos": Offset(0.15, 0.5),
      "icon": Icons.devices,
      "color": Colors.indigo
    },
    {
      "id": "ai",
      "pos": Offset(0.6, 0.1),
      "icon": Icons.smart_toy,
      "color": Colors.deepOrange
    },
    {
      "id": "linux",
      "pos": Offset(0.2, 0.2),
      "icon": Icons.terminal,
      "color": Colors.white
    },
    {
      "id": "riscv",
      "pos": Offset(0.8, 0.2),
      "icon": Icons.memory,
      "color": Colors.amberAccent
    },
    {
      "id": "embedded",
      "pos": Offset(0.3, 0.8),
      "icon": Icons.developer_board,
      "color": Colors.green
    },
    {
      "id": "system",
      "pos": Offset(0.7, 0.4),
      "icon": Icons.laptop_chromebook,
      "color": Colors.blueGrey
    },
  ];

  @override
  void initState() {
    super.initState();
    _particleMoveController = AnimationController(
      duration: const Duration(milliseconds: 16),
      vsync: this,
    )..addListener(_tick);
    _particleMoveController.repeat();

    _glowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _tick() {
    if (mounted && _size != Size.zero && _particles.isNotEmpty) {
      setState(() {
        for (var p in _particles) {
          p.update(_pointerPosition, _size, _particles);
        }
      });
    }
  }

  void _initializeParticles(Size size) {
    if (_initialized && size == _size) return;
    _size = size;
    _initialized = true;

    _particles = _initialNodes.map((nodeData) {
      final particle = Particle(
        id: nodeData['id'],
        initialPosition: Offset(
            nodeData['pos'].dx * size.width, nodeData['pos'].dy * size.height),
        icon: nodeData['icon'],
        color: nodeData['color'],
        phase: (nodeData['id'].hashCode % 1000 / 1000.0) * 2 * pi,
      );
      particle.initializeVelocity();
      return particle;
    }).toList();
  }

  void setPointer(Offset pos) {
    _pointerPosition = pos;
  }

  void clearPointer() {
    _pointerPosition = Offset.zero;
  }

  void applyClickImpulse(Offset clickPos,
      {double strength = 12.0, double maxRadius = 150.0}) {
    if (_particles.isEmpty) return;
    final rand = Random();
    for (var p in _particles) {
      final delta = p.position - clickPos;
      final dist = delta.distance;
      if (dist == 0) {
        final angle = rand.nextDouble() * 2 * pi;
        p.velocity += Offset(cos(angle), sin(angle)) * strength;
        continue;
      }
      if (dist < maxRadius) {
        final dir = delta / dist;
        final falloff = (1 - (dist / maxRadius)).clamp(0.0, 1.0);
        final applied = dir * (strength * falloff);
        p.velocity += applied;

        final maxSpeed = 10.0;
        if (p.velocity.distance > maxSpeed)
          p.velocity = p.velocity.normalize() * maxSpeed;
      }
    }
  }

  @override
  void dispose() {
    _particleMoveController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _initializeParticles(constraints.biggest);
        return CustomPaint(
          size: constraints.biggest,
          painter: _ParticlesPainter(
            particles: _particles,
            pointer: _pointerPosition,
            animation: _particleMoveController,
            glowAnimation: _glowController,
          ),
        );
      },
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final Offset pointer;
  final Animation<double> glowAnimation;

  static final Map<String, TextPainter> _textPainterCache = {};
  static final glowPaint = Paint()..style = PaintingStyle.fill;
  static final borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  _ParticlesPainter({
    required this.particles,
    required this.pointer,
    required Listenable animation,
    required this.glowAnimation,
  }) : super(repaint: Listenable.merge([animation, glowAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final glowValue = glowAnimation.value;

    for (var particle in particles) {
      if (!_textPainterCache.containsKey(particle.id)) {
        final textPainter = TextPainter(textDirection: TextDirection.ltr);
        textPainter.text = TextSpan(
          text: String.fromCharCode(particle.icon.codePoint),
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: particle.icon.fontFamily,
            color: particle.color.withOpacity(0.5),
            shadows: [
              Shadow(color: particle.color.withOpacity(0.2), blurRadius: 6.0),
            ],
          ),
        );
        textPainter.layout();
        _textPainterCache[particle.id] = textPainter;
      }

      final pos = particle.position;
      final glowAmount = (sin(particle.phase + glowValue * 2 * pi) + 1) / 2;

      glowPaint
        ..color = particle.color.withOpacity(0.2)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12.0 + glowAmount * 4);
      canvas.drawCircle(pos, 15.0 + glowAmount * 3, glowPaint);

      borderPaint.color = particle.color.withOpacity(0.4);
      canvas.drawCircle(pos, 12.0 + glowAmount * 2, borderPaint);

      borderPaint.color = particle.color.withOpacity(0.2);
      canvas.drawCircle(pos, 15.0 + glowAmount * 3, borderPaint);

      borderPaint.color = particle.color.withOpacity(0.1);
      canvas.drawCircle(pos, 20.0 + glowAmount * 5, borderPaint);

      final textPainter = _textPainterCache[particle.id];
      if (textPainter != null) {
        textPainter.paint(canvas,
            pos - Offset(textPainter.width / 2, textPainter.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.particles != particles || oldDelegate.pointer != pointer;
  }
}
