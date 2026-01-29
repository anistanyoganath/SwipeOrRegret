import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeorregret/core/utils/ads/ad_consent.dart';
import 'package:swipeorregret/features/game/models/game_state.dart';

class SplashController extends ChangeNotifier {
  bool _isLoading = true;
  GameState? _gameState;

  bool get isLoading => _isLoading;
  GameState? get gameState => _gameState;

  Future<void> initializeApp() async {
    try {
      // Load saved game state
      await _loadGameState();

      // Initialize services (Firebase, Ads, etc.)
      await _initializeServices();

      // Simulate minimum splash time
      await Future.delayed(const Duration(milliseconds: 1500));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Handle error but still proceed
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('game_state');

      if (json != null) {
        // Parse from JSON (you'd need to add fromJson to GameState)
        // _gameState = GameState.fromJson(jsonDecode(json));
      } else {
        _gameState = GameState();
      }
    } catch (e) {
      _gameState = GameState();
    }
  }

  Future<void> _initializeServices() async {
    consenting.updateConsent();

    // Initialize AdMob
    await MobileAds.instance.initialize();

    // Initialize audio service
    // await AudioService().initialize();
  }
}
