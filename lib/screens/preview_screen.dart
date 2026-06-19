import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../providers/sensor_provider.dart';
import '../providers/particle_provider.dart';
import '../widgets/hud_widgets.dart';
import '../widgets/particle_canvas.dart';
import '../models/effect_type.dart';
import '../utils/constants.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallpaper = context.watch<WallpaperProvider>();
    final sensor = context.watch<SensorProvider>();
    final particles = context.watch<ParticleProvider>();

    if (wallpaper.currentProject == null) {
      return const Scaffold(
        body: Center(child: Text('No hay proyecto activo')),
      );
    }

    final project = wallpaper.currentProject!;

    return Scaffold(
      backgroundColor: project.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('VISTA PREVIA'),
        actions: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) => Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.hudRed.withAlpha(51),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppConstants.hudRed.withAlpha(
                    (128 + 127 * _pulseController.value).toInt(),
                  ),
                ),
              ),
              child: Text(
                'REC',
                style: TextStyle(
                  color: AppConstants.hudRed.withAlpha(
                    (128 + 127 * _pulseController.value).toInt(),
                  ),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ...project.layers.where((l) => l.visible).map((layer) {
            final intensity = project.parallaxSensitivity * layer.depth;
            return Positioned.fill(
              child: ListenableBuilder(
                listenable: sensor,
                builder: (context, _) {
                  final dx = sensor.tiltX * intensity * 40 +
                      layer.offsetX * MediaQuery.of(context).size.width;
                  final dy = sensor.tiltY * intensity * 40 +
                      layer.offsetY * MediaQuery.of(context).size.height;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translate(dx, dy)
                      ..rotateZ(layer.rotation)
                      ..scale(layer.scale),
                    child: Opacity(
                      opacity: layer.opacity,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(layer.imagePath),
                            fit: BoxFit.contain,
                            onError: (_, __) {},
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          if (project.activeEffects.isNotEmpty)
            ParticleCanvas(particles: particles.particles),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppConstants.darkBg.withAlpha(179),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConstants.neonBlue.withAlpha(77),
                  ),
                ),
                child: Text(
                  'SENSIBILIDAD: ${project.parallaxSensitivity.toStringAsFixed(1)}x | CAPAS: ${project.layers.length}',
                  style: const TextStyle(
                    color: AppConstants.neonBlue,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
