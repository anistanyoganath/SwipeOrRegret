import 'package:swipeorregret/app/game_constants.dart';

class GameState {
  int money;
  int relationship;
  int stress;
  int reputation;
  int score;
  int currentScenarioIndex;
  DateTime? lastPlayed;
  int streakDays;

  GameState({
    this.money = GameConstants.initialMoney,
    this.relationship = GameConstants.initialRelationship,
    this.stress = GameConstants.initialStress,
    this.reputation = GameConstants.initialReputation,
    this.score = 0,
    this.currentScenarioIndex = 0,
    this.lastPlayed,
    this.streakDays = 0,
  });

  Map<String, dynamic> toJson() => {
    'money': money,
    'relationship': relationship,
    'stress': stress,
    'reputation': reputation,
    'score': score,
    'currentScenarioIndex': currentScenarioIndex,
    'lastPlayed': lastPlayed?.toIso8601String(),
    'streakDays': streakDays,
  };

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      money: json['money'] ?? GameConstants.initialMoney,
      relationship: json['relationship'] ?? GameConstants.initialRelationship,
      stress: json['stress'] ?? GameConstants.initialStress,
      reputation: json['reputation'] ?? GameConstants.initialReputation,
      score: json['score'] ?? 0,
      currentScenarioIndex: json['currentScenarioIndex'] ?? 0,
      lastPlayed: json['lastPlayed'] != null
          ? DateTime.parse(json['lastPlayed'])
          : null,
      streakDays: json['streakDays'] ?? 0,
    );
  }

  bool get isGameOver {
    return money <= 0 || relationship <= 0 || stress >= 100 || reputation <= 0;
  }

  void updateStats(Map<String, int> consequences) {
    money = (money + (consequences['money'] ?? 0)).clamp(
      GameConstants.minStats,
      GameConstants.maxStats,
    );
    relationship = (relationship + (consequences['relationship'] ?? 0)).clamp(
      GameConstants.minStats,
      GameConstants.maxStats,
    );
    stress = (stress + (consequences['stress'] ?? 0)).clamp(
      GameConstants.minStats,
      GameConstants.maxStats,
    );
    reputation = (reputation + (consequences['reputation'] ?? 0)).clamp(
      GameConstants.minStats,
      GameConstants.maxStats,
    );

    score += 10;
  }
}
