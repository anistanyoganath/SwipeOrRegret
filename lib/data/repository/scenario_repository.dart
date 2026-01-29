import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:swipeorregret/features/game/models/scenario.dart';

class ScenarioRepository {
  List<Scenario> _scenarios = [];

  Future<List<Scenario>> getScenarios() async {
    if (_scenarios.isNotEmpty) {
      return _scenarios;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/scenarios.json');
      final jsonData = json.decode(jsonString) as List;

      _scenarios = jsonData.map((item) => Scenario.fromJson(item)).toList();
      _scenarios.shuffle(); // Randomize order

      return _scenarios;
    } catch (e) {
      // Fallback scenarios
      return _getDefaultScenarios();
    }
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
      Scenario(
        id: '2',
        text: 'Your ex texts you at 1:30 AM. "I miss you."',
        leftConsequences: {'stress': -10, 'relationship': -5},
        rightConsequences: {'relationship': 15, 'stress': 10, 'reputation': -5},
        leftText: 'IGNORE',
        rightText: 'REPLY',
        category: 'Dating',
      ),
      // Add more default scenarios...
    ];
  }
}
