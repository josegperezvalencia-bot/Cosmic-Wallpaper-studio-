import 'package:flutter/material.dart';
import '../models/wallpaper_project.dart';
import '../services/export_service.dart';

class ExportProvider extends ChangeNotifier {
  final ExportService _exportService = ExportService();
  bool _isExporting = false;
  double _exportProgress = 0;
  String? _lastExportPath;

  bool get isExporting => _isExporting;
  double get exportProgress => _exportProgress;
  String? get lastExportPath => _lastExportPath;

  Future<String> exportWallpaper(WallpaperProject project,
      {bool is4K = false, bool asGIF = false, bool asMP4 = false}) async {
    _isExporting = true;
    _exportProgress = 0;
    notifyListeners();

    try {
      String path;
      for (double i = 0; i <= 1; i += 0.1) {
        await Future.delayed(const Duration(milliseconds: 50));
        _exportProgress = i;
        notifyListeners();
      }

      if (asGIF) {
        path = await _exportService.exportAsGIF(project);
      } else if (asMP4) {
        path = await _exportService.exportAsMP4(project);
      } else if (is4K) {
        path = await _exportService.exportAsImage(project);
      } else {
        path = await _exportService.exportAsWallpaper(project);
      }

      _lastExportPath = path;
      _exportProgress = 1.0;
      return path;
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }

  Future<List<String>> getExportedFiles() async {
    final files = await _exportService.getExportedFiles();
    return files.map((f) => f.path).toList();
  }
}
