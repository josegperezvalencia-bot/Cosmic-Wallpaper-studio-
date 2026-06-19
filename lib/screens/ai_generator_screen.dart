import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../providers/premium_provider.dart';
import '../widgets/hud_widgets.dart';
import '../models/premium_feature.dart';
import '../utils/constants.dart';

class AIGeneratorScreen extends StatefulWidget {
  const AIGeneratorScreen({super.key});

  @override
  State<AIGeneratorScreen> createState() => _AIGeneratorScreenState();
}

class _AIGeneratorScreenState extends State<AIGeneratorScreen> {
  final _promptController = TextEditingController();
  bool _isGenerating = false;

  final List<String> _presets = AppConstants.aiPresets;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final premium = context.watch<PremiumProvider>();
    final canGenerate = premium.hasFeature(PremiumFeature.aiGeneration);

    return Scaffold(
      appBar: AppBar(title: const Text('GENERADOR IA')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HUDPanel(
              title: 'Describe tu wallpaper',
              icon: Icons.auto_awesome,
              accentColor: AppConstants.neonPurple,
              child: Column(
                children: [
                  TextField(
                    controller: _promptController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: canGenerate
                          ? 'Ej: Planeta futurista azul en una galaxia...'
                          : 'Premium - Actualiza para usar IA',
                      hintStyle: TextStyle(
                        color: canGenerate
                            ? Colors.grey.shade500
                            : AppConstants.hudAmber,
                      ),
                    ),
                    enabled: canGenerate,
                  ),
                  const SizedBox(height: 16),
                  HUDButton(
                    label: _isGenerating ? 'GENERANDO...' : 'GENERAR',
                    icon: _isGenerating ? null : Icons.rocket_launch,
                    color: AppConstants.neonPurple,
                    isLoading: _isGenerating,
                    onPressed: canGenerate ? _generate : null,
                  ),
                  if (!canGenerate) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'La generación por IA es una función premium',
                      style: TextStyle(color: AppConstants.hudAmber, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'PRESETS RÁPIDOS',
              style: TextStyle(
                color: AppConstants.neonBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            ..._presets.map(
              (preset) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: canGenerate
                      ? () {
                          _promptController.text = preset;
                        }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppConstants.darkCard,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppConstants.neonBlue.withAlpha(51),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          size: 16,
                          color: AppConstants.neonPurple,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            preset,
                            style: TextStyle(
                              color: canGenerate
                                  ? Colors.white70
                                  : Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generate() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() => _isGenerating = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      context.read<WallpaperProvider>().generateWithAI(prompt);
      setState(() => _isGenerating = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wallpaper generado exitosamente'),
          backgroundColor: AppConstants.neonPurple,
        ),
      );
    }
  }
}
