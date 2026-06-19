import 'package:flutter/material.dart';
import 'wallpaper_layer.dart';
import 'effect_type.dart';

class WallpaperProject {
  String id;
  String name;
  List<WallpaperLayer> layers;
  List<EffectType> activeEffects;
  double parallaxSensitivity;
  Color backgroundColor;
  DateTime createdAt;
  DateTime modifiedAt;

  WallpaperProject({
    required this.id,
    required this.name,
    this.layers = const [],
    this.activeEffects = const [],
    this.parallaxSensitivity = 1.0,
    this.backgroundColor = const Color(0xFF0A0A0F),
    DateTime? createdAt,
    DateTime? modifiedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        modifiedAt = modifiedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'layers': layers.map((l) => l.toJson()).toList(),
        'activeEffects':
            activeEffects.map((e) => e.name).toList(),
        'parallaxSensitivity': parallaxSensitivity,
        'backgroundColor': backgroundColor.value,
        'createdAt': createdAt.toIso8601String(),
        'modifiedAt': modifiedAt.toIso8601String(),
      };

  factory WallpaperProject.fromJson(Map<String, dynamic> json) =>
      WallpaperProject(
        id: json['id'],
        name: json['name'],
        layers: (json['layers'] as List)
            .map((l) => WallpaperLayer.fromJson(l))
            .toList(),
        activeEffects: (json['activeEffects'] as List)
            .map((e) => EffectType.values.firstWhere((et) => et.name == e))
            .toList(),
        parallaxSensitivity:
            (json['parallaxSensitivity'] as num).toDouble(),
        backgroundColor:
            Color(json['backgroundColor'] as int),
        createdAt: DateTime.parse(json['createdAt']),
        modifiedAt: DateTime.parse(json['modifiedAt']),
      );
}
