import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../providers/premium_provider.dart';
import '../widgets/hud_widgets.dart';
import '../widgets/effect_card.dart';
import '../models/effect_type.dart';
import '../utils/constants.dart';

class EffectsScreen extends StatelessWidget {
  const EffectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallpaper = context.watch<WallpaperProvider>();
    final project = wallpaper.currentProject;

    return Scaffold(
      appBar: AppBar(title: const Text('EFECTOS')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EFECTOS VISUALES',
              style: TextStyle(
                color: AppConstants.neonBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            ...EffectType.values.map((effect) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: EffectCard(
                    effect: effect,
                    isActive:
                        project?.activeEffects.contains(effect) ?? false,
                    onToggle: () => wallpaper.toggleEffect(effect),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
