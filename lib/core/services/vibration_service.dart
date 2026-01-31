import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VibrationService {
  static final VibrationService _instance = VibrationService._internal();
  factory VibrationService() => _instance;
  VibrationService._internal();

  bool _vibrationEnabled = true;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
  }

  Future<void> toggleVibration(bool enabled) async {
    _vibrationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration_enabled', enabled);
  }

  Future<void> vibrateSwipe() async {
    if (!_vibrationEnabled) return;

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 50, amplitude: 128);
    }
  }

  Future<void> vibrateDecision() async {
    if (!_vibrationEnabled) return;

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 100, amplitude: 255);
    }
  }

  Future<void> vibrateGameOver() async {
    if (!_vibrationEnabled) return;

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(
        pattern: [0, 100, 200, 100, 200, 100],
        intensities: [0, 255, 0, 255, 0, 255],
      );
    }
  }

  Future<void> vibrateButton() async {
    if (!_vibrationEnabled) return;

    if (await Vibration.hasVibrator()) {
      HapticFeedback.lightImpact();
    }
  }

  bool get vibrationEnabled => _vibrationEnabled;
}
