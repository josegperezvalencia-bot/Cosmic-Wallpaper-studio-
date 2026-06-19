import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/effect_type.dart';

class ParticleEffectService {
  static final ParticleEffectService _instance =
      ParticleEffectService._();
  factory ParticleEffectService() => _instance;
  ParticleEffectService._();

  final Random _rng = Random();
  Timer? _updateTimer;
  final StreamController<List<Particle2D>> _particleController =
      StreamController<List<Particle2D>>.broadcast();
  List<Particle2D> _particles = [];
  List<EffectType> _activeEffects = [];
  double _width = 0;
  double _height = 0;

  Stream<List<Particle2D>> get particleStream =>
      _particleController.stream;

  void initialize(double width, double height) {
    _width = width;
    _height = height;
    _updateTimer = Timer.periodic(
      const Duration(milliseconds: 33),
      (_) => _update(),
    );
  }

  void setActiveEffects(List<EffectType> effects) {
    _activeEffects = List.from(effects);
    _particles = [];
    _spawnParticles();
  }

  void resize(double width, double height) {
    _width = width;
    _height = height;
    _particles = [];
    _spawnParticles();
  }

  void _spawnParticles() {
    for (final effect in _activeEffects) {
      switch (effect) {
        case EffectType.spaceParticles:
          for (int i = 0; i < 50; i++) {
            _particles.add(Particle2D.randomSpace(_width, _height, _rng));
          }
        case EffectType.animatedStars:
          for (int i = 0; i < 100; i++) {
            _particles.add(Particle2D.randomStar(_width, _height, _rng));
          }
        case EffectType.nebula:
          for (int i = 0; i < 3; i++) {
            final centerX = _rng.nextDouble() * _width;
            final centerY = _rng.nextDouble() * _height;
            final color = [
              const Color(0xFF8B5CF6),
              const Color(0xFF00D4FF),
              const Color(0xFFFF1493),
            ][_rng.nextInt(3)];
            for (int j = 0; j < 30; j++) {
              _particles.add(Particle2D.randomNebula(
                  centerX, centerY, 100 + _rng.nextDouble() * 100, color, _rng));
            }
          }
        case EffectType.neonGlow:
          for (int i = 0; i < 20; i++) {
            _particles.add(Particle2D.randomGlow(_width, _height, _rng));
          }
        case EffectType.floatingPlanets:
          for (int i = 0; i < 3; i++) {
            _particles.add(Particle2D.randomPlanet(_width, _height, _rng));
          }
        case EffectType.meteorShower:
          for (int i = 0; i < 5; i++) {
            _particles.add(Particle2D.randomMeteor(_width, _height, _rng));
          }
      }
    }
  }

  void _update() {
    final dt = 0.033;

    for (int i = _particles.length - 1; i >= 0; i--) {
      _particles[i].update(dt, _width, _height, _rng);

      if (_activeEffects.contains(EffectType.meteorShower) &&
          _particles[i].type == ParticleType.meteor &&
          !_particles[i].isAlive) {
        _particles[i] = Particle2D.randomMeteor(_width, _height, _rng);
      }
    }

    if (_particles.length < 200 && _rng.nextDouble() < 0.1) {
      final extraEffects =
          _activeEffects.where((e) => e == EffectType.spaceParticles).toList();
      if (extraEffects.isNotEmpty) {
        _particles
            .add(Particle2D.randomSpace(_width, _height, _rng));
      }
    }

    _particleController.add(List.from(_particles));
  }

  void dispose() {
    _updateTimer?.cancel();
    _particleController.close();
  }
}

enum ParticleType {
  space,
  star,
  nebula,
  glow,
  planet,
  meteor,
}

class Particle2D {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double opacity;
  double rotation;
  double rotationSpeed;
  Color color;
  double life;
  double maxLife;
  final ParticleType type;

  Particle2D({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.opacity,
    required this.rotation,
    this.rotationSpeed = 0,
    required this.color,
    required this.life,
    required this.maxLife,
    required this.type,
  });

  bool get isAlive => life > 0;

  void update(double dt, double width, double height, Random rng) {
    x += vx * dt;
    y += vy * dt;
    rotation += rotationSpeed * dt;
    life -= dt;

    if (type == ParticleType.star) {
      opacity = 0.3 + 0.7 * (0.5 + 0.5 * sin(life * 2));
    } else if (type == ParticleType.meteor) {
      opacity = (life / maxLife).clamp(0.0, 1.0);
    }

    if (x < -size) x = width + size;
    if (x > width + size) x = -size;
    if (y < -size) y = height + size;
    if (y > height + size) {
      if (type == ParticleType.meteor) {
        y = -size;
      } else {
        y = -size;
      }
    }
  }

  static Particle2D randomSpace(double w, double h, Random rng) {
    return Particle2D(
      x: rng.nextDouble() * w,
      y: rng.nextDouble() * h,
      vx: (rng.nextDouble() - 0.5) * 15,
      vy: (rng.nextDouble() - 0.5) * 15,
      size: rng.nextDouble() * 2 + 0.5,
      opacity: rng.nextDouble() * 0.8 + 0.2,
      rotation: 0,
      color: Colors.white,
      life: double.infinity,
      maxLife: double.infinity,
      type: ParticleType.space,
    );
  }

  static Particle2D randomStar(double w, double h, Random rng) {
    final colors = [
      Colors.white,
      const Color(0xFF00D4FF),
      const Color(0xFFFFF8E7),
      const Color(0xFF8B5CF6),
    ];
    return Particle2D(
      x: rng.nextDouble() * w,
      y: rng.nextDouble() * h,
      vx: 0,
      vy: 0,
      size: rng.nextDouble() * 3 + 1,
      opacity: rng.nextDouble() * 0.5 + 0.5,
      rotation: rng.nextDouble() * 6.28,
      rotationSpeed: (rng.nextDouble() - 0.5) * 2,
      color: colors[rng.nextInt(colors.length)],
      life: double.infinity,
      maxLife: double.infinity,
      type: ParticleType.star,
    );
  }

  static Particle2D randomNebula(
      double cx, double cy, double radius, Color nebulaColor, Random rng) {
    final angle = rng.nextDouble() * 2 * pi;
    final dist = rng.nextDouble() * radius;
    return Particle2D(
      x: cx + cos(angle) * dist,
      y: cy + sin(angle) * dist,
      vx: (rng.nextDouble() - 0.5) * 3,
      vy: (rng.nextDouble() - 0.5) * 3,
      size: rng.nextDouble() * 40 + 15,
      opacity: rng.nextDouble() * 0.2 + 0.05,
      rotation: rng.nextDouble() * 6.28,
      rotationSpeed: (rng.nextDouble() - 0.5) * 0.3,
      color: nebulaColor,
      life: double.infinity,
      maxLife: double.infinity,
      type: ParticleType.nebula,
    );
  }

  static Particle2D randomGlow(double w, double h, Random rng) {
    final colors = [
      const Color(0xFF00D4FF),
      const Color(0xFF00FFE0),
      const Color(0xFF8B5CF6),
      const Color(0xFFFF1493),
    ];
    return Particle2D(
      x: rng.nextDouble() * w,
      y: rng.nextDouble() * h,
      vx: (rng.nextDouble() - 0.5) * 10,
      vy: (rng.nextDouble() - 0.5) * 10,
      size: rng.nextDouble() * 8 + 3,
      opacity: rng.nextDouble() * 0.4 + 0.1,
      rotation: rng.nextDouble() * 6.28,
      rotationSpeed: (rng.nextDouble() - 0.5) * 1,
      color: colors[rng.nextInt(colors.length)],
      life: double.infinity,
      maxLife: double.infinity,
      type: ParticleType.glow,
    );
  }

  static Particle2D randomPlanet(double w, double h, Random rng) {
    final planetColors = [
      const Color(0xFF00D4FF),
      const Color(0xFF8B5CF6),
      const Color(0xFFFF1493),
      const Color(0xFFFFB300),
      const Color(0xFF00FF88),
    ];
    return Particle2D(
      x: rng.nextDouble() * w,
      y: rng.nextDouble() * h,
      vx: (rng.nextDouble() - 0.5) * 5,
      vy: (rng.nextDouble() - 0.5) * 5,
      size: rng.nextDouble() * 20 + 10,
      opacity: 0.8,
      rotation: rng.nextDouble() * 6.28,
      rotationSpeed: (rng.nextDouble() - 0.5) * 0.5,
      color: planetColors[rng.nextInt(planetColors.length)],
      life: double.infinity,
      maxLife: double.infinity,
      type: ParticleType.planet,
    );
  }

  static Particle2D randomMeteor(double w, double h, Random rng) {
    return Particle2D(
      x: rng.nextDouble() * w,
      y: -20,
      vx: (rng.nextDouble() - 0.3) * 100 - 100,
      vy: 150 + rng.nextDouble() * 200,
      size: rng.nextDouble() * 3 + 1.5,
      opacity: 1.0,
      rotation: atan2(150, -100),
      color: const Color(0xFFFFB300),
      life: 3.0 + rng.nextDouble() * 2.0,
      maxLife: 5.0,
      type: ParticleType.meteor,
    );
  }
}
