import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SensorService {
  static final SensorService _instance = SensorService._();
  factory SensorService() => _instance;
  SensorService._();

  double _tiltX = 0.0;
  double _tiltY = 0.0;
  bool _isAvailable = false;
  Timer? _simulationTimer;
  final Random _rng = Random();

  double get tiltX => _tiltX;
  double get tiltY => _tiltY;
  bool get isAvailable => _isAvailable;

  Stream<SensorData> get sensorStream => _sensorController.stream;
  final StreamController<SensorData> _sensorController =
      StreamController<SensorData>.broadcast();

  Future<void> initialize() async {
    _isAvailable = true;
    _startSimulation();
  }

  void _startSimulation() {
    double targetX = 0, targetY = 0;
    _simulationTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) {
        targetX += (_rng.nextDouble() - 0.5) * 0.2;
        targetY += (_rng.nextDouble() - 0.5) * 0.2;
        targetX = targetX.clamp(-1.0, 1.0);
        targetY = targetY.clamp(-1.0, 1.0);

        _tiltX += (targetX - _tiltX) * 0.05;
        _tiltY += (targetY - _tiltY) * 0.05;

        _sensorController.add(SensorData(
          tiltX: _tiltX,
          tiltY: _tiltY,
          timestamp: DateTime.now(),
        ));
      },
    );
  }

  void simulateTilt(double x, double y) {
    _tiltX = x.clamp(-1.0, 1.0);
    _tiltY = y.clamp(-1.0, 1.0);
    _sensorController.add(SensorData(
      tiltX: _tiltX,
      tiltY: _tiltY,
      timestamp: DateTime.now(),
    ));
  }

  void dispose() {
    _simulationTimer?.cancel();
    _sensorController.close();
  }
}

class SensorData {
  final double tiltX;
  final double tiltY;
  final DateTime timestamp;

  SensorData({
    required this.tiltX,
    required this.tiltY,
    required this.timestamp,
  });
}
