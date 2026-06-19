import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../providers/sensor_provider.dart';
import '../providers/particle_provider.dart';
import '../providers/premium_provider.dart';
import '../widgets/hud_widgets.dart';
import '../widgets/particle_canvas.dart';
import '../widgets/effect_card.dart';
import '../widgets/parallax_preview.dart';
import '../widgets/layer_widget.dart';
import '../widgets/export_dialog.dart';
import '../models/effect_type.dart';
import '../models/premium_feature.dart';
import '../utils/constants.dart';
import 'preview_screen.dart';
import 'ai_generator_screen.dart';
import 'effects_screen.dart';
import 'gallery_screen.dart';
import 'settings_screen.dart';
import 'premium_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  final _screens = const [
    _CreatorTab(),
    _GalleryTab(),
    _SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentNavIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppConstants.neonBlue.withAlpha(38),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentNavIndex,
          onTap: (i) => setState(() => _currentNavIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize),
              label: 'CREAR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_library),
              label: 'GALERÍA',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'AJUSTES',
            ),
          ],
        ),
      ),
    );
  }
}

class _CreatorTab extends StatelessWidget {
  const _CreatorTab();

  @override
  Widget build(BuildContext context) {
    final wallpaper = context.watch<WallpaperProvider>();
    final sensor = context.watch<SensorProvider>();

    if (wallpaper.currentProject == null) {
      return _buildEmptyState(context, wallpaper);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(wallpaper.currentProject!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            onPressed: () => _showPreview(context),
            tooltip: 'Vista Previa',
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: () => _openAIGenerator(context),
            tooltip: 'Generar con IA',
          ),
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () => wallpaper.saveProject(),
            tooltip: 'Guardar',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: _buildPreview(context, wallpaper, sensor),
          ),
          Expanded(
            flex: 4,
            child: _buildEditorPanel(context, wallpaper),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WallpaperProvider wallpaper) {
    return Scaffold(
      appBar: AppBar(title: const Text('COSMIC WALLPAPER STUDIO')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppConstants.neonBlue.withAlpha(77),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.neonBlue.withAlpha(26),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.dashboard_customize,
                size: 56,
                color: AppConstants.neonBlue,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'COSMIC WALLPAPER',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'STUDIO',
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.neonBlue,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 40),
            HUDButton(
              label: 'NUEVO PROYECTO',
              icon: Icons.add,
              onPressed: () => wallpaper.createNewProject(),
            ),
            const SizedBox(height: 16),
            HUDButton(
              label: 'GENERAR CON IA',
              icon: Icons.auto_awesome,
              color: AppConstants.neonPurple,
              onPressed: () => _openAIGenerator(context),
            ),
            const SizedBox(height: 16),
            HUDButton(
              label: 'CARGAR PROYECTO',
              icon: Icons.folder_open,
              color: AppConstants.neonCyan,
              isOutlined: true,
              onPressed: () {
                wallpaper.loadProjects();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(
      BuildContext context, WallpaperProvider wallpaper, SensorProvider sensor) {
    final project = wallpaper.currentProject!;
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.neonBlue.withAlpha(51),
          width: 0.5,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: project.backgroundColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  for (final layer in project.layers)
                    if (layer.visible)
                      Positioned.fill(
                        child: ParallaxPreview(
                          sensitivity:
                              project.parallaxSensitivity * layer.depth,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..translate(
                                  layer.offsetX *
                                      MediaQuery.of(context).size.width,
                                  layer.offsetY *
                                      MediaQuery.of(context).size.height)
                              ..rotateZ(layer.rotation)
                              ..scale(layer.scale),
                            child: Opacity(
                              opacity: layer.opacity,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage(layer.imagePath),
                                    fit: BoxFit.contain,
                                    onError: (_, __) {},
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.darkBg.withAlpha(179),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'SENS: ${project.parallaxSensitivity.toStringAsFixed(1)}x',
                style: const TextStyle(
                  color: AppConstants.neonBlue,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (project.layers.isEmpty)
            const Center(
              child: Text(
                'Añade capas para comenzar',
                style: TextStyle(color: Colors.white24, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEditorPanel(
      BuildContext context, WallpaperProvider wallpaper) {
    final project = wallpaper.currentProject!;
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppConstants.neonBlue.withAlpha(38),
                  width: 0.5,
                ),
              ),
            ),
            child: TabBar(
              indicatorColor: AppConstants.neonBlue,
              labelColor: AppConstants.neonBlue,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.layers), text: 'CAPAS'),
                Tab(icon: Icon(Icons.auto_fix_high), text: 'EFECTOS'),
                Tab(icon: Icon(Icons.tune), text: 'AJUSTES'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildLayersTab(context, wallpaper, project),
                _buildEffectsTab(context, wallpaper),
                _buildSettingsTab(context, wallpaper, project),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayersTab(
      BuildContext context, WallpaperProvider wallpaper, dynamic project) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: HUDButton(
              label: 'AÑADIR CAPA',
              icon: Icons.add_photo_alternate,
              onPressed: () => _addLayer(context, wallpaper),
            ),
          ),
          if (wallpaper.selectedLayer != null)
            LayerEditorWidget(
              layer: wallpaper.selectedLayer!,
              onChanged: (layer) {
                if (wallpaper.selectedLayerIndex >= 0) {
                  wallpaper.updateLayer(wallpaper.selectedLayerIndex, layer);
                }
              },
            ),
          LayerListWidget(
            layers: wallpaper.currentProject!.layers,
            selectedIndex: wallpaper.selectedLayerIndex,
            onSelect: wallpaper.selectLayer,
            onDelete: wallpaper.removeLayer,
            onReorder: wallpaper.reorderLayer,
          ),
        ],
      ),
    );
  }

  Widget _buildEffectsTab(
      BuildContext context, WallpaperProvider wallpaper) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EFECTOS DISPONIBLES',
            style: TextStyle(
              color: AppConstants.neonBlue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemCount: EffectType.values.length,
            itemBuilder: (context, index) {
              final effect = EffectType.values[index];
              return EffectCard(
                effect: effect,
                isActive:
                    wallpaper.currentProject!.activeEffects.contains(effect),
                onToggle: () => wallpaper.toggleEffect(effect),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Los efectos se aplican en la vista previa',
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab(
      BuildContext context, WallpaperProvider wallpaper, dynamic project) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          HUDPanel(
            title: 'Parallax',
            icon: Icons.zoom_out_map,
            child: HUDSlider(
              label: 'Sensibilidad',
              value: project.parallaxSensitivity,
              min: 0.0,
              max: 3.0,
              divisions: 300,
              onChanged: wallpaper.setParallaxSensitivity,
              displayValue: (v) => '${v.toStringAsFixed(1)}x',
            ),
          ),
          HUDPanel(
            title: 'Proyecto',
            icon: Icons.info_outline,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nombre: ${project.name}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Capas: ${project.layers.length}/10',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Creado: ${project.createdAt.toString().substring(0, 16)}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                HUDButton(
                  label: 'RENOMBRAR',
                  icon: Icons.edit,
                  onPressed: () => _renameProject(context, wallpaper),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: HUDButton(
                    label: 'VISTA PREVIA',
                    icon: Icons.play_arrow,
                    onPressed: () => _showPreview(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: HUDButton(
                    label: 'EXPORTAR',
                    icon: Icons.file_download,
                    color: AppConstants.hudGreen,
                    onPressed: () =>
                        ExportDialog.show(context, wallpaper.currentProject!),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addLayer(BuildContext context, WallpaperProvider wallpaper) {
    wallpaper.addLayer('assets/images/default_layer.png');
  }

  void _showPreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PreviewScreen(),
      ),
    );
  }

  void _openAIGenerator(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AIGeneratorScreen(),
      ),
    );
  }

  void _renameProject(BuildContext context, WallpaperProvider wallpaper) {
    final controller =
        TextEditingController(text: wallpaper.currentProject?.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppConstants.darkCard,
        title: const Text('Renombrar Proyecto',
            style: TextStyle(color: AppConstants.neonBlue)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nombre del proyecto',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              wallpaper.renameProject(controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class _GalleryTab extends StatelessWidget {
  const _GalleryTab();

  @override
  Widget build(BuildContext context) {
    return const GalleryScreen();
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    return const SettingsScreen();
  }
}
