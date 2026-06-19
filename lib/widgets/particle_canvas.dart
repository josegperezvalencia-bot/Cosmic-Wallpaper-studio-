import 'dart:math';
import 'package:flutter/material.dart';
import '../services/particle_effect_service.dart';
import '../utils/constants.dart';

class ParticleCanvas extends StatelessWidget {
  final List<Particle2D> particles;

  const ParticleCanvas({super.key, required this.particles});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ParticlePainter(particles),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle2D> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()..color = p.color.withAlpha((p.opacity * 255).toInt());

      switch (p.type) {
        case ParticleType.star:
          _drawStar(canvas, p, paint);
          break;
        case ParticleType.nebula:
          _drawNebula(canvas, p, paint);
          break;
        case ParticleType.glow:
          _drawGlow(canvas, p, paint);
          break;
        case ParticleType.planet:
          _drawPlanet(canvas, p, paint);
          break;
        case ParticleType.meteor:
          _drawMeteor(canvas, p, paint);
          break;
        default:
          canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Particle2D p, Paint paint) {
    final opacity = p.opacity;
    final basePaint = Paint()
      ..color = Colors.white.withAlpha((opacity * 255).toInt());

    canvas.drawCircle(Offset(p.x, p.y), p.size, basePaint);

    if (p.size > 1.5) {
      final glowPaint = Paint()
        ..color = p.color.withAlpha(((opacity * 0.3) * 255).toInt());
      canvas.drawCircle(Offset(p.x, p.y), p.size * 2.5, glowPaint);
    }
  }

  void _drawNebula(Canvas canvas, Particle2D p, Paint paint) {
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);
    canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
  }

  void _drawGlow(Canvas canvas, Particle2D p, Paint paint) {
    final gradient = RadialGradient(
      colors: [
        p.color.withAlpha(128),
        p.color.withAlpha(26),
        Colors.transparent,
      ],
    );

    final shaderPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: Offset(p.x, p.y), radius: p.size * 2),
      );

    canvas.drawCircle(Offset(p.x, p.y), p.size * 2, shaderPaint);
    canvas.drawCircle(Offset(p.x, p.y), p.size * 0.3, paint);
  }

  void _drawPlanet(Canvas canvas, Particle2D p, Paint paint) {
    canvas.save();
    canvas.translate(p.x, p.y);
    canvas.rotate(p.rotation);

    final planetPaint = Paint()
      ..color = p.color.withAlpha((p.opacity * 255).toInt())
      ..shader = RadialGradient(
        colors: [
          p.color,
          p.color.withAlpha(179),
          p.color.withAlpha(77),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: p.size));

    canvas.drawCircle(Offset.zero, p.size, planetPaint);

    final glowPaint = Paint()
      ..color = p.color.withAlpha(51)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, p.size * 0.5);

    canvas.drawCircle(Offset.zero, p.size * 1.5, glowPaint);

    canvas.restore();
  }

  void _drawMeteor(Canvas canvas, Particle2D p, Paint paint) {
    canvas.save();
    canvas.translate(p.x, p.y);
    canvas.rotate(p.rotation);

    final headPaint = Paint()
      ..color = const Color(0xFFFFB300).withAlpha((p.opacity * 255).toInt());

    canvas.drawCircle(Offset.zero, p.size, headPaint);

    final trailPaint = Paint()
      ..color = const Color(0xFFFFB300).withAlpha(((p.opacity * 0.3) * 255).toInt())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawRect(
      Rect.fromCenter(center: Offset(-15, 0), width: 30, height: 2),
      trailPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

class StarField extends StatelessWidget {
  final int starCount;
  final double twinkleSpeed;

  const StarField({
    super.key,
    this.starCount = 80,
    this.twinkleSpeed = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _StarFieldPainter(
        starCount: starCount,
        twinkleSpeed: twinkleSpeed,
      ),
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  final int starCount;
  final double twinkleSpeed;

  _StarFieldPainter({required this.starCount, required this.twinkleSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final time = DateTime.now().millisecondsSinceEpoch / 1000;

    for (int i = 0; i < starCount; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final baseSize = rng.nextDouble() * 2 + 0.5;
      final phase = rng.nextDouble() * 2 * pi;

      final twinkle = 0.5 + 0.5 * sin(time * twinkleSpeed + phase);
      final size2 = baseSize * (0.5 + 0.5 * twinkle);

      final opacity = (0.3 + 0.7 * twinkle).toDouble().clamp(0.0, 1.0);
      final paint = Paint()
        ..color = Colors.white.withAlpha((opacity * 255).toInt());

      canvas.drawCircle(Offset(x, y), size2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) => true;
}

class AnimatedBackground extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.backgroundColor = AppConstants.darkBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Stack(
        children: [
          const StarField(),
          child,
        ],
      ),
    );
  }
}
