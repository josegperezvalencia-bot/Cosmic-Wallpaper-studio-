import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/wallpaper_project.dart';

class ExportService {
  static final ExportService _instance = ExportService._();
  factory ExportService() => _instance;
  ExportService._();

  Future<String> exportAsWallpaper(WallpaperProject project) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/wallpapers/${project.id}.wp';
    await File(path).writeAsString(project.toJson().toString());
    return path;
  }

  Future<String> exportAsImage(WallpaperProject project) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/exports/${project.id}_4k.png';
    final file = File(path);
    await file.create(recursive: true);
    return path;
  }

  Future<String> exportAsGIF(WallpaperProject project) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/exports/${project.id}.gif';
    final file = File(path);
    await file.create(recursive: true);
    return path;
  }

  Future<String> exportAsMP4(WallpaperProject project) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/exports/${project.id}.mp4';
    final file = File(path);
    await file.create(recursive: true);
    return path;
  }

  Future<List<FileSystemEntity>> getExportedFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${dir.path}/exports');
    if (await exportDir.exists()) {
      return exportDir.listSync();
    }
    return [];
  }
}
