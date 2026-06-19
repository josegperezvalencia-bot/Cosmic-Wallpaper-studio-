import 'package:flutter/material.dart';
import '../models/effect_type.dart';
import '../utils/constants.dart';
import '../providers/premium_provider.dart';
import 'package:provider/provider.dart';

class EffectCard extends StatelessWidget {
  final EffectType effect;
  final bool isActive;
  final VoidCallback onToggle;

  const EffectCard({
    super.key,
    required this.effect,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final premium = context.watch<PremiumProvider>();
    final isLocked = effect.isPremium && !premium.hasFeature(PremiumFeature.allEffects);

    return GestureDetector(
      onTap: isLocked ? () => _showPremiumDialog(context) : onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: isActive
              ? AppConstants.neonBlue.withAlpha(26)
              : AppConstants.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppConstants.neonBlue
                : AppConstants.neonBlue.withAlpha(38),
            width: isActive ? 1.5 : 0.5,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(
                  _getIcon(),
                  color: isActive
                      ? AppConstants.neonBlue
                      : (isLocked ? Colors.grey : Colors.white54),
                  size: 28,
                ),
                if (isLocked)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.lock,
                      color: AppConstants.hudAmber,
                      size: 14,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              effect.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive
                    ? AppConstants.neonBlue
                    : (isLocked ? Colors.grey : Colors.white70),
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (effect) {
      case EffectType.spaceParticles:
        return Icons.blur_on;
      case EffectType.animatedStars:
        return Icons.star_rate;
      case EffectType.nebula:
        return Icons.cloud;
      case EffectType.neonGlow:
        return Icons.flare;
      case EffectType.floatingPlanets:
        return Icons.circle;
      case EffectType.meteorShower:
        return Icons.travel_explore;
    }
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppConstants.hudAmber, width: 0.5),
        ),
        title: const Row(
          children: [
            Icon(Icons.workspace_premium, color: AppConstants.hudAmber),
            SizedBox(width: 8),
            Text('Premium', style: TextStyle(color: AppConstants.hudAmber)),
          ],
        ),
        content: const Text(
          'Este efecto es premium. ¡Desbloquea todos los efectos con la suscripción Premium!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Más tarde'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PremiumProvider>().unlockPremium();
            },
            child: const Text('Desbloquear'),
          ),
        ],
      ),
    );
  }
}
