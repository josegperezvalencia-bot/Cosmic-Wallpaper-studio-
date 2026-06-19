import 'dart:math';
import 'package:flutter/material.dart';
import '../models/wallpaper_project.dart';
import '../models/wallpaper_layer.dart';
import 'package:uuid/uuid.dart';

class AIService {
  static final AIService _instance = AIService._();
  factory AIService() => _instance;
  AIService._();

  final _uuid = const Uuid();
  final _rng = Random();

  WallpaperProject generateFromPrompt(String prompt) {
    final project = WallpaperProject(
      id: _uuid.v4(),
      name: _sanitizeName(prompt),
      backgroundColor: const Color(0xFF0A0A0F),
      parallaxSensitivity: 0.8 + _rng.nextDouble() * 0.4,
    );

    final layers = <WallpaperLayer>[];
    final baseLayer = WallpaperLayer(
      id: _uuid.v4(),
      imagePath: 'ai_generated_base',
      depth: -2.0,
      scale: 1.2,
      opacity: 0.9,
    );
    layers.add(baseLayer);

    if (prompt.toLowerCase().contains('planeta')) {
      final planetLayer = WallpaperLayer(
        id: _uuid.v4(),
        imagePath: 'ai_generated_planet',
        depth: 1.0,
        scale: 0.8 + _rng.nextDouble() * 0.3,
        offsetY: -0.1,
      );
      layers.add(planetLayer);

      final glowLayer = WallpaperLayer(
        id: _uuid.v4(),
        imagePath: 'ai_generated_glow',
        depth: 0.0,
        scale: 1.5,
        opacity: 0.4,
      );
      layers.add(glowLayer);
    }

    if (prompt.toLowerCase().contains('ciudad') ||
        prompt.toLowerCase().contains('cyberpunk')) {
      for (int i = 0; i < 3; i++) {
        layers.add(WallpaperLayer(
          id: _uuid.v4(),
          imagePath: 'ai_generated_city_layer_$i',
          depth: -1.0 + i * 1.5,
          scale: 1.0 + i * 0.1,
          offsetY: 0.2 - i * 0.1,
        ));
      }
    }

    if (prompt.toLowerCase().contains('galaxia') ||
        prompt.toLowerCase().contains('nebulosa')) {
      final nebulaLayer = WallpaperLayer(
        id: _uuid.v4(),
        imagePath: 'ai_generated_nebula',
        depth: -3.0,
        scale: 1.5,
        opacity: 0.6,
      );
      layers.add(nebulaLayer);
    }

    if (prompt.toLowerCase().contains('agujero') ||
        prompt.toLowerCase().contains('black')) {
      final holeLayer = WallpaperLayer(
        id: _uuid.v4(),
        imagePath: 'ai_generated_blackhole',
        depth: 0.5,
        scale: 0.7,
        rotation: 0.5,
      );
      layers.add(holeLayer);

      final ringLayer = WallpaperLayer(
        id: _uuid.v4(),
        imagePath: 'ai_generated_ring',
        depth: 2.0,
        scale: 1.3,
        opacity: 0.7,
        rotation: 0.3,
      );
      layers.add(ringLayer);
    }

    project.layers = layers;
    return project;
  }

  String _sanitizeName(String prompt) {
    if (prompt.length > 30) {
      return prompt.substring(0, 27) + '...';
    }
    return prompt;
  }
}
