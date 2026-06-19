import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../widgets/hud_widgets.dart';
import '../widgets/layer_widget.dart';

class CreatorScreen extends StatelessWidget {
  const CreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallpaper = context.watch<WallpaperProvider>();

    if (wallpaper.currentProject == null) {
      return const Scaffold(
        body: Center(child: Text('No hay proyecto activo')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(wallpaper.currentProject!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => wallpaper.saveProject(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            HUDPanel(
              title: 'Capas',
              icon: Icons.layers,
              child: Column(
                children: [
                  HUDButton(
                    label: 'AÑADIR CAPA',
                    icon: Icons.add,
                    onPressed: () =>
                        wallpaper.addLayer('assets/images/default.png'),
                  ),
                  const SizedBox(height: 16),
                  LayerListWidget(
                    layers: wallpaper.currentProject!.layers,
                    selectedIndex: wallpaper.selectedLayerIndex,
                    onSelect: wallpaper.selectLayer,
                    onDelete: wallpaper.removeLayer,
                    onReorder: wallpaper.reorderLayer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
