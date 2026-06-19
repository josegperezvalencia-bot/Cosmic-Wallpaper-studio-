import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double opacity;
  final Color color;
  double life;
  double maxLife;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.opacity,
    required this.color,
    required this.life,
    required this.maxLife,
  });

  void update(double dt) {
    x += vx * dt;
    y += vy * dt;
    life -= dt;
    opacity = (life / maxLife).clamp(0.0, 1.0);
  }

  bool get isAlive => life > 0;

  static Particle randomSpaceParticle(double width, double height, Random rng) {
    return Particle(
      x: rng.nextDouble() * width,
      y: rng.nextDouble() * height,
      vx: (rng.nextDouble() - 0.5) * 20,
      vy: (rng.nextDouble() - 0.5) * 20,
      size: rng.nextDouble() * 2 + 0.5,
      opacity: rng.nextDouble() * 0.8 + 0.2,
      color: Colors.white,
      life: 5.0 + rng.nextDouble() * 5.0,
      maxLife: 10.0,
    );
  }

  static Particle randomStar(double width, double height, Random rng) {
    final colors = [
      Colors.white,
      const Color(0xFF00D4FF),
      const Color(0xFFFFF8E7),
      const Color(0xFF8B5CF6),
    ];
    final twinkle = rng.nextDouble() * 0.5 + 0.5;
    return Particle(
      x: rng.nextDouble() * width,
      y: rng.nextDouble() * height,
      vx: 0.0,
      vy: 0.0,
      size: rng.nextDouble() * 3 + 1,
      opacity: twinkle,
      color: colors[rng.nextInt(colors.length)],
      life: double.infinity,
      maxLife: double.infinity,
    );
  }

  static Particle randomNebulaParticle(
      double cx, double cy, double radius, Color nebulaColor, Random rng) {
    final angle = rng.nextDouble() * 2 * pi;
    final dist = rng.nextDouble() * radius;
    return Particle(
      x: cx + cos(angle) * dist,
      y: cy + sin(angle) * dist,
      vx: (rng.nextDouble() - 0.5) * 5,
      vy: (rng.nextDouble() - 0.5) * 5,
      size: rng.nextDouble() * 30 + 10,
      opacity: rng.nextDouble() * 0.3,
      color: nebulaColor,
      life: double.infinity,
      maxLife: double.infinity,
    );
  }

  static Particle randomMeteor(
      double width, double height, Random rng) {
    final startX = rng.nextDouble() * width;
    final speed = 200 + rng.nextDouble() * 400;
    return Particle(
      x: startX,
      y: -10,
      vx: -speed * 0.4,
      vy: speed,
      size: rng.nextDouble() * 3 + 2,
      opacity: 1.0,
      color: const Color(0xFFFFB300),
      life: 2.0 + rng.nextDouble() * 1.5,
      maxLife: 3.5,
    );
  }
}
