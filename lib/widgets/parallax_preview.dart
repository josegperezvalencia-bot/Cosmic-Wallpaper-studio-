import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../utils/constants.dart';

class ParallaxPreview extends StatefulWidget {
  final Widget child;
  final double sensitivity;
  final bool enableParallax;

  const ParallaxPreview({
    super.key,
    required this.child,
    this.sensitivity = 1.0,
    this.enableParallax = true,
  });

  @override
  State<ParallaxPreview> createState() => _ParallaxPreviewState();
}

class _ParallaxPreviewState extends State<ParallaxPreview> {
  @override
  Widget build(BuildContext context) {
    if (!widget.enableParallax) return widget.child;

    return Consumer<SensorProvider>(
      builder: (context, sensor, _) {
        final dx = sensor.tiltX * widget.sensitivity * 20;
        final dy = sensor.tiltY * widget.sensitivity * 20;

        return Transform.translate(
          offset: Offset(dx, dy),
          child: widget.child,
        );
      },
    );
  }
}

class LayerPreview extends StatelessWidget {
  final String imagePath;
  final double depth;
  final double parallaxSensitivity;
  final double offsetX;
  final double offsetY;
  final double scale;
  final double rotation;
  final double opacity;

  const LayerPreview({
    super.key,
    required this.imagePath,
    this.depth = 0.0,
    this.parallaxSensitivity = 1.0,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SensorProvider>(
      builder: (context, sensor, _) {
        final intensity = parallaxSensitivity * depth;
        final dx = sensor.tiltX * intensity * 30 +
            offsetX * MediaQuery.of(context).size.width;
        final dy = sensor.tiltY * intensity * 30 +
            offsetY * MediaQuery.of(context).size.height;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(dx, dy)
            ..rotateZ(rotation)
            ..scale(scale),
          child: Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConstants.neonBlue.withAlpha(77),
                  width: 0.5,
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
