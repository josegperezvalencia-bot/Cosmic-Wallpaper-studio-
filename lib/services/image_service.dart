import 'package:flutter/material.dart';
import '../models/wallpaper_project.dart';

class ImageService {
  static final ImageService _instance = ImageService._();
  factory ImageService() => _instance;
  ImageService._();

  final List<WallpaperProject> _projects = [];

  List<WallpaperProject> get projects => List.unmodifiable(_projects);

  Future<void> loadProjects() async {}

  Future<void> saveProject(WallpaperProject project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index >= 0) {
      _projects[index] = project;
    } else {
      _projects.add(project);
    }
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
  }

  void addProject(WallpaperProject project) {
    _projects.add(project);
  }
}
