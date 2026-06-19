import 'dart:async';
import 'package:flutter/material.dart';
import '../models/effect_type.dart';
import '../services/particle_effect_service.dart';

class ParticleProvider extends ChangeNotifier {
  final ParticleEffectService _service = ParticleEffectService();
  StreamSubscription<List<Particle2D>>? _subscription;
  List<Particle2D> _particles = [];

  List<Particle2D> get particles => _particles;

  void initialize(double width, double height) {
    _service.initialize(width, height);
    _subscription = _service.particleStream.listen((particles) {
      _particles = particles;
      notifyListeners();
    });
  }

  void setEffects(List<EffectType> effects) {
    _service.setActiveEffects(effects);
  }

  void resize(double width, double height) {
    _service.resize(width, height);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _service.dispose();
    super.dispose();
  }
}
