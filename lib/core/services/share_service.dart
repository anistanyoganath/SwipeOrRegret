import 'package:share_plus/share_plus.dart';

class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  Future<void> shareResult(int score, int daysSurvived) async {
    final text =
        '''
🚀 I survived $daysSurvived days in Swipe or Regret!
🏆 Score: $score

Can you beat my score? 

#SwipeOrRegret #DecisionGame #MobileGame
''';

    await Share.share(text, subject: 'My Swipe or Regret Score');
  }

  Future<void> shareApp() async {
    const text = '''
🎮 Check out Swipe or Regret - The Ultimate Decision-Making Game!

One choice. No undo. Make quick decisions and face the consequences!

👉 Download now and test your decision-making skills!

#SwipeOrRegret #NewGame #MobileGame #DecisionGame
''';

    await Share.share(text, subject: 'Amazing Game - Swipe or Regret');
  }

  Future<void> shareScenario(
    String scenario,
    String decision,
    String outcome,
  ) async {
    final text =
        '''
🤔 Scenario: $scenario
✅ Decision: $decision
🎯 Outcome: $outcome

What would you choose? Play Swipe or Regret now!

#SwipeOrRegret #DecisionTime #WhatWouldYouDo
''';

    await Share.share(text, subject: 'Interesting Decision in Swipe or Regret');
  }
}
