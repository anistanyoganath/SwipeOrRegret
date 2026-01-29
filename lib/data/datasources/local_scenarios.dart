const List<Map<String, dynamic>> localScenarios = [
  {
    "id": 1,
    "text": "Your boss asks you to lie to a client.",
    "yesEffect": {"money": 10, "health": 0, "stress": 15, "reputation": -5},
    "noEffect": {"money": -5, "health": 5, "stress": -5, "reputation": 10},
  },
  {
    "id": 2,
    "text": "Your ex texts you at midnight.",
    "yesEffect": {"money": 0, "health": -5, "stress": 10, "reputation": -5},
    "noEffect": {"money": 0, "health": 5, "stress": -5, "reputation": 5},
  },
];
