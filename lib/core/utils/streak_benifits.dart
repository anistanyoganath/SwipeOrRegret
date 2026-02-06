class StreakRewardSystem {
  static Map<int, Map<String, dynamic>> streakRewards = {
    3: {
      'bonus': 10,
      'message': '3-Day Streak! +10 starting money',
      'type': 'money',
    },
    7: {
      'bonus': 20,
      'message': '7-Day Streak! +20 starting money',
      'type': 'money',
    },
    14: {
      'bonus': 30,
      'message': '2-Week Streak! +30 starting money & stress reduction',
      'type': 'combo',
    },
    30: {
      'bonus': 50,
      'message': '1-Month Streak! +50 starting money & reputation boost',
      'type': 'combo',
    },
  };

  static Map<String, int> getStreakBonus(int streakDays) {
    final bonus = {'money': 0, 'stress': 0, 'reputation': 0};

    if (streakDays >= 30) {
      bonus['money'] = 50;
      bonus['reputation'] = 10;
    } else if (streakDays >= 14) {
      bonus['money'] = 30;
      bonus['stress'] = -5;
    } else if (streakDays >= 7) {
      bonus['money'] = 20;
    } else if (streakDays >= 3) {
      bonus['money'] = 10;
    }

    return bonus;
  }

  static String? getStreakMessage(int streakDays) {
    return streakRewards[streakDays]?['message'];
  }
}
