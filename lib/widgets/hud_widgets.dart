import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HUDPanel extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;
  final Color accentColor;
  final EdgeInsets padding;

  const HUDPanel({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.accentColor = AppConstants.neonBlue,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withAlpha(77), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(13),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: accentColor.withAlpha(38),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: accentColor, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }
}

class HUDButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final bool isOutlined;
  final bool isLoading;

  const HUDButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.color = AppConstants.neonBlue,
    this.isOutlined = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color.withAlpha(38),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: onPressed != null ? color : color.withAlpha(77),
          width: isOutlined ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (!isOutlined)
            BoxShadow(
              color: color.withAlpha(26),
              blurRadius: 8,
              spreadRadius: 0,
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading) ...[
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (icon != null && !isLoading) ...[
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
          ],
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: onPressed != null ? color : color.withAlpha(128),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );

    if (onPressed == null) return widget;
    return GestureDetector(onTap: onPressed, child: widget);
  }
}

class HUDSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String Function(double)? displayValue;
  final ValueChanged<double> onChanged;

  const HUDSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions = 100,
    this.displayValue,
  });

  @override
  Widget build(BuildContext context) {
    final display = displayValue?.call(value) ?? value.toStringAsFixed(2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: AppConstants.neonBlue,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            Text(
              display,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class HUDDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final Color accentColor;

  const HUDDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.accentColor = AppConstants.neonBlue,
  });

  static Future<T?> show<T>(BuildContext context,
      {required String title, required Widget content, List<Widget>? actions}) {
    return showDialog<T>(
      context: context,
      builder: (context) => HUDDialog(
        title: title,
        content: content,
        actions: actions ?? [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppConstants.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentColor.withAlpha(77), width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                color: accentColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: accentColor.withAlpha(51)),
            const SizedBox(height: 16),
            content,
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: actions,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
