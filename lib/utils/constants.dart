import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Cosmic Wallpaper Studio';
  static const String appVersion = '1.0.0';

  static const Color neonBlue = Color(0xFF00D4FF);
  static const Color neonCyan = Color(0xFF00FFE0);
  static const Color neonPurple = Color(0xFF8B5CF6);
  static const Color neonPink = Color(0xFFFF1493);
  static const Color darkBg = Color(0xFF0A0A0F);
  static const Color darkCard = Color(0xFF12121A);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color hudGreen = Color(0xFF00FF88);
  static const Color hudAmber = Color(0xFFFFB300);
  static const Color hudRed = Color(0xFFFF3333);

  static const double maxLayers = 10;
  static const double minDepth = -5.0;
  static const double maxDepth = 5.0;
  static const double defaultSensitivity = 1.0;

  static const Duration sensorUpdateInterval = Duration(milliseconds: 16);
  static const Duration animationDuration = Duration(milliseconds: 300);

  static const String premiumExport4K = '4K Export';
  static const String premiumEffects = 'All Effects';
  static const String premiumNoAds = 'Ad-Free';

  static const List<String> aiPresets = [
    'Planeta futurista azul en una galaxia',
    'Ciudad cyberpunk espacial',
    'Agujero negro con luces neón',
    'Nebulosa púrpura con estrellas brillantes',
    'Estación espacial abandonada',
    'Lluvia de meteoritos sobre un planeta',
    'Aurora boreal extraterrestre',
    'Puente de luz entre dos galaxias',
  ];
}
