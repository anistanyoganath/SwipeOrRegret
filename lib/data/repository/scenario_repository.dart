import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:swipeorregret/features/game/models/scenario.dart';

class ScenarioRepository {
  List<Scenario> _scenarios = [];

  Future<List<Scenario>> getScenarios({String? languageCode}) async {
    if (_scenarios.isNotEmpty && languageCode == null) {
      return _scenarios;
    }

    try {
      final lang = languageCode ?? 'en';
      final jsonString = await rootBundle.loadString(
        'assets/scenarios/$lang.json',
      );
      final jsonData = json.decode(jsonString) as List;

      _scenarios = jsonData.map((item) => Scenario.fromJson(item)).toList();
      _scenarios.shuffle(); // Randomize order

      return _scenarios;
    } catch (e) {
      print('Error loading scenarios for language $languageCode: $e');

      // Fallback to English
      if (languageCode != 'en') {
        return await getScenarios(languageCode: 'en');
      }

      // If English also fails, use default scenarios
      return _getDefaultScenarios();
    }
  }

  // Get scenarios based on current locale
  Future<List<Scenario>> getLocalizedScenarios(BuildContext context) async {
    final locale = Localizations.localeOf(context);
    return await getScenarios(languageCode: locale.languageCode);
  }

  List<Scenario> _getDefaultScenarios() {
    return [
      Scenario(
        id: '1',
        text: 'Your boss asks you to lie to a client. Promotion guaranteed.',
        leftConsequences: {'money': -10, 'reputation': 15, 'stress': 5},
        rightConsequences: {'money': 20, 'reputation': -15, 'stress': 10},
        category: 'Career',
      ),
    ];
  }
}
