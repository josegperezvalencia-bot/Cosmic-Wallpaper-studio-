import 'package:flutter/material.dart';
import '../models/wallpaper_layer.dart';
import '../utils/constants.dart';
import 'hud_widgets.dart';

class LayerListWidget extends StatelessWidget {
  final List<WallpaperLayer> layers;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final ValueChanged<int> onDelete;
  final ReorderCallback onReorder;

  const LayerListWidget({
    super.key,
    required this.layers,
    required this.selectedIndex,
    required this.onSelect,
    required this.onDelete,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    if (layers.isEmpty) {
      return const HUDPanel(
        title: 'Capas',
        child: Text(
          'Añade imágenes para crear capas',
          style: TextStyle(color: Colors.white38, fontSize: 13),
        ),
      );
    }

    return HUDPanel(
      title: 'Capas (${layers.length}/10)',
      child: ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: layers.length,
        onReorder: onReorder,
        itemBuilder: (context, index) {
          final layer = layers[index];
          final isSelected = index == selectedIndex;
          return Container(
            key: ValueKey(layer.id),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppConstants.neonBlue.withAlpha(26)
                  : AppConstants.darkSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppConstants.neonBlue
                    : AppConstants.neonBlue.withAlpha(38),
                width: isSelected ? 1.5 : 0.5,
              ),
            ),
            child: ListTile(
              dense: true,
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppConstants.darkBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppConstants.neonBlue.withAlpha(51),
                  ),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  color: AppConstants.neonBlue,
                  size: 18,
                ),
              ),
              title: Text(
                'Capa ${index + 1}',
                style: TextStyle(
                  color: isSelected ? AppConstants.neonBlue : Colors.white70,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                'Profundidad: ${layer.depth.toStringAsFixed(1)}',
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    layer.visible ? Icons.visibility : Icons.visibility_off,
                    color: layer.visible ? AppConstants.neonBlue : Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onDelete(index),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ),
                  const Icon(
                    Icons.drag_handle,
                    color: Colors.white24,
                    size: 18,
                  ),
                ],
              ),
              onTap: () => onSelect(index),
            ),
          );
        },
      ),
    );
  }
}

class LayerEditorWidget extends StatelessWidget {
  final WallpaperLayer layer;
  final ValueChanged<WallpaperLayer> onChanged;

  const LayerEditorWidget({
    super.key,
    required this.layer,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return HUDPanel(
      title: 'Editar Capa',
      icon: Icons.tune,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HUDSlider(
            label: 'Profundidad',
            value: layer.depth,
            min: -5.0,
            max: 5.0,
            divisions: 100,
            onChanged: (v) => onChanged(layer.copyWith(depth: v)),
          ),
          HUDSlider(
            label: 'Escala',
            value: layer.scale,
            min: 0.1,
            max: 3.0,
            divisions: 290,
            onChanged: (v) => onChanged(layer.copyWith(scale: v)),
          ),
          HUDSlider(
            label: 'Rotación',
            value: layer.rotation,
            min: -3.14159,
            max: 3.14159,
            divisions: 628,
            displayValue: (v) => '${(v * 180 / 3.14159).round()}°',
            onChanged: (v) => onChanged(layer.copyWith(rotation: v)),
          ),
          HUDSlider(
            label: 'Opacidad',
            value: layer.opacity,
            min: 0.0,
            max: 1.0,
            divisions: 100,
            onChanged: (v) => onChanged(layer.copyWith(opacity: v)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'VISIBLE',
                style: TextStyle(
                  color: AppConstants.neonBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Switch(
                value: layer.visible,
                onChanged: (v) => onChanged(layer.copyWith(visible: v)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
