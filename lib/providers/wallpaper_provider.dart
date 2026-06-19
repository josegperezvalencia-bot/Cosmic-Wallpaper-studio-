import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/wallpaper_project.dart';
import '../models/wallpaper_layer.dart';
import '../models/effect_type.dart';
import '../services/image_service.dart';
import '../services/ai_service.dart';

class WallpaperProvider extends ChangeNotifier {
  final ImageService _imageService = ImageService();
  final AIService _aiService = AIService();
  final _uuid = const Uuid();

  WallpaperProject? _currentProject;
  List<WallpaperProject> _projects = [];
  int _selectedLayerIndex = -1;

  WallpaperProject? get currentProject => _currentProject;
  List<WallpaperProject> get projects => _projects;
  int get selectedLayerIndex => _selectedLayerIndex;
  WallpaperLayer? get selectedLayer =>
      _currentProject != null && _selectedLayerIndex >= 0 &&
              _selectedLayerIndex < _currentProject!.layers.length
          ? _currentProject!.layers[_selectedLayerIndex]
          : null;

  void createNewProject() {
    _currentProject = WallpaperProject(
      id: _uuid.v4(),
      name: 'Nuevo Proyecto ${_projects.length + 1}',
    );
    _selectedLayerIndex = -1;
    notifyListeners();
  }

  void loadProject(WallpaperProject project) {
    _currentProject = project;
    _selectedLayerIndex = -1;
    notifyListeners();
  }

  void addLayer(String imagePath) {
    if (_currentProject == null) return;
    if (_currentProject!.layers.length >= 10) return;

    final layer = WallpaperLayer(
      id: _uuid.v4(),
      imagePath: imagePath,
      depth: 0.0,
    );
    _currentProject!.layers.add(layer);
    _selectedLayerIndex = _currentProject!.layers.length - 1;
    _currentProject!.modifiedAt = DateTime.now();
    notifyListeners();
  }

  void removeLayer(int index) {
    if (_currentProject == null) return;
    if (index < 0 || index >= _currentProject!.layers.length) return;

    _currentProject!.layers.removeAt(index);
    if (_selectedLayerIndex >= _currentProject!.layers.length) {
      _selectedLayerIndex = _currentProject!.layers.length - 1;
    }
    _currentProject!.modifiedAt = DateTime.now();
    notifyListeners();
  }

  void updateLayer(int index, WallpaperLayer layer) {
    if (_currentProject == null) return;
    if (index < 0 || index >= _currentProject!.layers.length) return;

    _currentProject!.layers[index] = layer;
    _currentProject!.modifiedAt = DateTime.now();
    notifyListeners();
  }

  void selectLayer(int index) {
    _selectedLayerIndex = index;
    notifyListeners();
  }

  void reorderLayer(int oldIndex, int newIndex) {
    if (_currentProject == null) return;
    if (newIndex > oldIndex) newIndex--;
    final layer = _currentProject!.layers.removeAt(oldIndex);
    _currentProject!.layers.insert(newIndex, layer);
    _selectedLayerIndex = newIndex;
    _currentProject!.modifiedAt = DateTime.now();
    notifyListeners();
  }

  void updateLayerDepth(int index, double depth) {
    if (_currentProject == null) return;
    if (index < 0 || index >= _currentProject!.layers.length) return;

    _currentProject!.layers[index] =
        _currentProject!.layers[index].copyWith(depth: depth);
    _currentProject!.modifiedAt = DateTime.now();
    notifyListeners();
  }

  void setParallaxSensitivity(double value) {
    if (_currentProject == null) return;
    _currentProject!.parallaxSensitivity = value;
    _currentProject!.modifiedAt = DateTime.now();
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    if (_currentProject == null) return;
    _currentProject!.backgroundColor = color;
    _currentProject!.modifiedAt = DateTime.now();
    notifyListeners();
  }

  void toggleEffect(EffectType effect) {
    if (_currentProject == null) return;
    if (_currentProject!.activeEffects.contains(effect)) {
      _currentProject!.activeEffects.remove(effect);
    } else {
      _currentProject!.activeEffects.add(effect);
    }
    _currentProject!.modifiedAt = DateTime.now();
    notifyListeners();
  }

  void saveProject() {
    if (_currentProject == null) return;
    final index = _projects.indexWhere((p) => p.id == _currentProject!.id);
    if (index >= 0) {
      _projects[index] = _currentProject!;
    } else {
      _projects.add(_currentProject!);
    }
    _imageService.saveProject(_currentProject!);
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((p) => p.id == id);
    _imageService.deleteProject(id);
    if (_currentProject?.id == id) {
      _currentProject = null;
    }
    notifyListeners();
  }

  void loadProjects() {
    _projects = List.from(_imageService.projects);
    notifyListeners();
  }

  WallpaperProject generateWithAI(String prompt) {
    final project = _aiService.generateFromPrompt(prompt);
    _currentProject = project;
    _selectedLayerIndex = -1;
    notifyListeners();
    return project;
  }

  void renameProject(String name) {
    if (_currentProject == null) return;
    _currentProject!.name = name;
    _currentProject!.modifiedAt = DateTime.now();
    notifyListeners();
  }
}
