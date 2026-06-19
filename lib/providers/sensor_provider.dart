import 'dart:async';
import 'package:flutter/material.dart';
import '../services/sensor_service.dart';

class SensorProvider extends ChangeNotifier {
  final SensorService _sensorService = SensorService();
  StreamSubscription<SensorData>? _subscription;

  double _tiltX = 0.0;
  double _tiltY = 0.0;
  bool _isInitialized = false;

  double get tiltX => _tiltX;
  double get tiltY => _tiltY;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    await _sensorService.initialize();
    _isInitialized = true;

    _subscription = _sensorService.sensorStream.listen((data) {
      _tiltX = data.tiltX;
      _tiltY = data.tiltY;
      notifyListeners();
    });
  }

  void simulateTilt(double x, double y) {
    _sensorService.simulateTilt(x, y);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _sensorService.dispose();
    super.dispose();
  }
}
