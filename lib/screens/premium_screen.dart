import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/premium_provider.dart';
import '../widgets/hud_widgets.dart';
import '../models/premium_feature.dart';
import '../utils/constants.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final premium = context.watch<PremiumProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PREMIUM'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    AppConstants.neonPurple.withAlpha(38),
                    AppConstants.neonBlue.withAlpha(38),
                  ],
                ),
                border: Border.all(
                  color: AppConstants.hudAmber.withAlpha(77),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppConstants.hudAmber,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.hudAmber.withAlpha(38),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      size: 40,
                      color: AppConstants.hudAmber,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'COSMIC PREMIUM',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Desbloquea todo el potencial',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...PremiumFeature.values.map((feature) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstants.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppConstants.neonBlue.withAlpha(51),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppConstants.darkSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          premium.hasFeature(feature)
                              ? Icons.check_circle
                              : Icons.lock_outline,
                          color: premium.hasFeature(feature)
                              ? AppConstants.hudGreen
                              : Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feature.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              feature.description,
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (premium.hasFeature(feature))
                        const Icon(
                          Icons.verified,
                          color: AppConstants.hudGreen,
                          size: 20,
                        ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            HUDButton(
              label: premium.isPremium
                  ? 'PREMIUM ACTIVADO'
                  : 'ACTUALIZAR AHORA - \$4.99',
              icon: Icons.workspace_premium,
              color: AppConstants.hudAmber,
              onPressed: premium.isPremium
                  ? null
                  : () {
                      context.read<PremiumProvider>().unlockPremium();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡Premium activado!'),
                          backgroundColor: AppConstants.hudAmber,
                        ),
                      );
                      Navigator.pop(context);
                    },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
