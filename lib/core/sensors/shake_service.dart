import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeService {
  static const double _shakeThreshold = 25.0;
  static const int _minTimeBetweenShakes = 600; // milliseconds

  StreamSubscription<AccelerometerEvent>? _subscription;
  int _lastShakeTime = 0;
  final VoidCallback onShake;

  ShakeService({required this.onShake});

  void start() {
    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      final double acceleration = sqrt(
        event.x * event.x +
            event.y * event.y +
            event.z * event.z,
      );

      if (acceleration > _shakeThreshold) {
        final int now = DateTime.now().millisecondsSinceEpoch;
        if (now - _lastShakeTime > _minTimeBetweenShakes) {
          _lastShakeTime = now;
          onShake();
        }
      }
    });
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }
}