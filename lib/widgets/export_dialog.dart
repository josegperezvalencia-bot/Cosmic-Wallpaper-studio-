import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/export_provider.dart';
import '../providers/premium_provider.dart';
import '../models/wallpaper_project.dart';
import '../models/premium_feature.dart';
import '../utils/constants.dart';
import 'hud_widgets.dart';

class ExportDialog extends StatelessWidget {
  final WallpaperProject project;

  const ExportDialog({super.key, required this.project});

  static Future<void> show(BuildContext context, WallpaperProject project) {
    return showDialog(
      context: context,
      builder: (context) => ExportDialog(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    final premium = context.watch<PremiumProvider>();
    final exportProvider = context.watch<ExportProvider>();

    return HUDDialog(
      title: 'Exportar Wallpaper',
      accentColor: AppConstants.hudGreen,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ExportOption(
            icon: Icons.wallpaper,
            label: 'Fondo Animado',
            description: 'Guardar como fondo animado',
            onTap: () => _export(context, exportProvider, false, false, false),
            isLoading: exportProvider.isExporting,
          ),
          const SizedBox(height: 12),
          _ExportOption(
            icon: Icons.image,
            label: 'Imagen 4K',
            description: 'Captura estática en 4K',
            isPremium: true,
            isLocked: !premium.hasFeature(PremiumFeature.export4K),
            onTap: () => _export(context, exportProvider, true, false, false),
            isLoading: exportProvider.isExporting,
          ),
          const SizedBox(height: 12),
          _ExportOption(
            icon: Icons.gif,
            label: 'GIF Animado',
            description: 'Exportar como GIF',
            isPremium: true,
            isLocked: !premium.hasFeature(PremiumFeature.gifExport),
            onTap: () => _export(context, exportProvider, false, true, false),
            isLoading: exportProvider.isExporting,
          ),
          const SizedBox(height: 12),
          _ExportOption(
            icon: Icons.videocam,
            label: 'Video MP4',
            description: 'Exportar como video MP4',
            isPremium: true,
            isLocked: !premium.hasFeature(PremiumFeature.mp4Export),
            onTap: () => _export(context, exportProvider, false, false, true),
            isLoading: exportProvider.isExporting,
          ),
          if (exportProvider.isExporting) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: exportProvider.exportProgress,
              backgroundColor: AppConstants.darkSurface,
              valueColor: const AlwaysStoppedAnimation(AppConstants.hudGreen),
            ),
            const SizedBox(height: 8),
            Text(
              '${(exportProvider.exportProgress * 100).toInt()}%',
              style: const TextStyle(color: AppConstants.hudGreen),
            ),
          ],
          if (exportProvider.lastExportPath != null) ...[
            const SizedBox(height: 16),
            const Text(
              '¡Exportado exitosamente!',
              style: TextStyle(color: AppConstants.hudGreen),
            ),
          ],
        ],
      ),
      actions: [
        HUDButton(
          label: 'Cerrar',
          onPressed: () => Navigator.pop(context),
          isOutlined: true,
        ),
      ],
    );
  }

  void _export(BuildContext context, ExportProvider exportProvider,
      bool is4K, bool asGIF, bool asMP4) async {
    Navigator.pop(context);
    await exportProvider.exportWallpaper(
      project,
      is4K: is4K,
      asGIF: asGIF,
      asMP4: asMP4,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Wallpaper exportado exitosamente'),
          backgroundColor: AppConstants.hudGreen,
        ),
      );
    }
  }
}

class _ExportOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;
  final bool isPremium;
  final bool isLocked;
  final bool isLoading;

  const _ExportOption({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
    this.isPremium = false,
    this.isLocked = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? () => _showLocked(context) : (isLoading ? null : onTap),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppConstants.darkSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isLocked ? Colors.grey.withAlpha(77) : AppConstants.neonBlue.withAlpha(77),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLocked ? Colors.grey : AppConstants.neonBlue,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: isLocked ? Colors.grey : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isPremium) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.workspace_premium,
                          size: 14,
                          color: isLocked ? Colors.grey : AppConstants.hudAmber,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: isLocked ? Colors.grey : Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isLocked)
              const Icon(Icons.lock, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  void _showLocked(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label es premium. ¡Actualiza para desbloquear!'),
        backgroundColor: AppConstants.hudAmber,
      ),
    );
  }
}
