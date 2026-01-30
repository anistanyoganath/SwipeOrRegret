import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _soundEnabled = true;
  bool _musicEnabled = true;

  // Volume levels
  double _bgmVolume = 0.5;
  double _sfxVolume = 0.7;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('sound_enabled') ?? true;
    _musicEnabled = prefs.getBool('music_enabled') ?? true;

    // Set audio mode
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  // Play background music
  Future<void> playBGM(String assetPath) async {
    if (!_musicEnabled) return;

    try {
      await _bgmPlayer.stop();
      await _bgmPlayer.setVolume(_bgmVolume);
      await _bgmPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print('Error playing BGM: $e');
    }
  }

  // Play sound effects
  Future<void> playSwipeSound() async {
    if (!_soundEnabled) return;
    await _playSFX('sounds/swipe.mp3');
  }

  Future<void> playDecisionSound() async {
    if (!_soundEnabled) return;
    await _playSFX('sounds/decision.mp3');
  }

  Future<void> playGameOverSound() async {
    if (!_soundEnabled) return;
    await _playSFX('sounds/game_over.mp3');
  }

  Future<void> playButtonClick() async {
    if (!_soundEnabled) return;
    await _playSFX('sounds/click.mp3');
  }

  Future<void> playStatChange(bool positive) async {
    if (!_soundEnabled) return;
    await _playSFX(positive ? 'sounds/positive.mp3' : 'sounds/negative.mp3');
  }

  Future<void> _playSFX(String assetPath) async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(_sfxVolume);
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print('Error playing SFX: $e');
    }
  }

  // Toggle methods
  Future<void> toggleSound(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', enabled);
  }

  Future<void> toggleMusic(bool enabled) async {
    _musicEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music_enabled', enabled);

    if (!enabled) {
      await _bgmPlayer.stop();
    } else if (_bgmPlayer.state == PlayerState.stopped) {
      await playBGM('sounds/bgm.mp3');
    }
  }

  // Volume control
  Future<void> setBGMVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);
    await _bgmPlayer.setVolume(_bgmVolume);
  }

  Future<void> setSFXVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
  }

  // Cleanup
  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    await _sfxPlayer.dispose();
  }

  // Getters
  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
}
