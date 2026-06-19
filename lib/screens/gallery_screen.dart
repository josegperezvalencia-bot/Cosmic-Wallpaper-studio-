import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../widgets/hud_widgets.dart';
import '../utils/constants.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallpaper = context.watch<WallpaperProvider>();
    final projects = wallpaper.projects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GALERÍA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => wallpaper.loadProjects(),
          ),
        ],
      ),
      body: projects.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: Colors.white24,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay proyectos guardados',
                    style: TextStyle(color: Colors.white38, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppConstants.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppConstants.neonBlue.withAlpha(51),
                      width: 0.5,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppConstants.darkSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppConstants.neonBlue.withAlpha(77),
                        ),
                      ),
                      child: const Icon(
                        Icons.wallpaper,
                        color: AppConstants.neonBlue,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      project.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Capas: ${project.layers.length} | ${project.createdAt.toString().substring(0, 10)}',
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.open_in_new,
                              color: AppConstants.neonBlue, size: 20),
                          onPressed: () =>
                              wallpaper.loadProject(project),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent, size: 20),
                          onPressed: () =>
                              _deleteProject(context, wallpaper, project.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _deleteProject(
      BuildContext context, WallpaperProvider wallpaper, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppConstants.darkCard,
        title: const Text('Eliminar Proyecto'),
        content:
            const Text('¿Estás seguro de eliminar este proyecto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              wallpaper.deleteProject(id);
              Navigator.pop(ctx);
            },
            child: const Text('Eliminar',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
