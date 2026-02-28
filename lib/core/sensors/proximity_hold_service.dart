import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityHoldService {
  final int holdMs;
  final int cooldownMs;
  final VoidCallback onTriggered;

  StreamSubscription<int>? _sub;
  Timer? _holdTimer;

  bool _isNear = false;

  // after triggering, must see FAR once before allowing again
  bool _needsFarReset = false;

  int _lastTriggerTime = 0;

  ProximityHoldService({
    required this.onTriggered,
    this.holdMs = 500,
    this.cooldownMs = 1500,
  });

  void start() {
    _sub = ProximitySensor.events.listen(
          (int v) {
        final now = DateTime.now().millisecondsSinceEpoch;

        // In this plugin, events are int. Commonly 1 = NEAR, 0 = FAR.
        // We treat any value > 0 as NEAR to be safe across devices.
        final bool nearNow = v > 0;

        // must go FAR once after a trigger
        if (_needsFarReset) {
          if (!nearNow) {
            _needsFarReset = false;
          } else {
            return;
          }
        }

        // cooldown
        if (now - _lastTriggerTime < cooldownMs) {
          _cancelHoldTimer();
          _isNear = nearNow;
          return;
        }

        // FAR -> NEAR starts timer
        if (nearNow && !_isNear) {
          _startHoldTimer();
        }

        // NEAR -> FAR cancels timer (if not completed)
        if (!nearNow && _isNear) {
          _cancelHoldTimer();
        }

        _isNear = nearNow;
      },
      onError: (_) {},
      cancelOnError: false,
    );
  }

  void stop() {
    _cancelHoldTimer();
    _sub?.cancel();
    _sub = null;
  }

  void _startHoldTimer() {
    _cancelHoldTimer();
    _holdTimer = Timer(Duration(milliseconds: holdMs), () {
      _holdTimer = null;
      _lastTriggerTime = DateTime.now().millisecondsSinceEpoch;
      _needsFarReset = true;
      onTriggered();
    });
  }

  void _cancelHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }
}