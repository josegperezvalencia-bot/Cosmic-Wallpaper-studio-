
class WallpaperLayer {
  String id;
  String imagePath;
  double depth;
  double offsetX;
  double offsetY;
  double scale;
  double rotation;
  double opacity;
  bool visible;

  WallpaperLayer({
    required this.id,
    required this.imagePath,
    this.depth = 0.0,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.opacity = 1.0,
    this.visible = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'imagePath': imagePath,
        'depth': depth,
        'offsetX': offsetX,
        'offsetY': offsetY,
        'scale': scale,
        'rotation': rotation,
        'opacity': opacity,
        'visible': visible,
      };

  factory WallpaperLayer.fromJson(Map<String, dynamic> json) =>
      WallpaperLayer(
        id: json['id'],
        imagePath: json['imagePath'],
        depth: (json['depth'] as num).toDouble(),
        offsetX: (json['offsetX'] as num).toDouble(),
        offsetY: (json['offsetY'] as num).toDouble(),
        scale: (json['scale'] as num).toDouble(),
        rotation: (json['rotation'] as num).toDouble(),
        opacity: (json['opacity'] as num).toDouble(),
        visible: json['visible'],
      );

  WallpaperLayer copyWith({
    String? id,
    String? imagePath,
    double? depth,
    double? offsetX,
    double? offsetY,
    double? scale,
    double? rotation,
    double? opacity,
    bool? visible,
  }) =>
      WallpaperLayer(
        id: id ?? this.id,
        imagePath: imagePath ?? this.imagePath,
        depth: depth ?? this.depth,
        offsetX: offsetX ?? this.offsetX,
        offsetY: offsetY ?? this.offsetY,
        scale: scale ?? this.scale,
        rotation: rotation ?? this.rotation,
        opacity: opacity ?? this.opacity,
        visible: visible ?? this.visible,
      );
}
