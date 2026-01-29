class Scenario {
  final String id;
  final String text;
  final Map<String, int> leftConsequences; // Swipe left consequences
  final Map<String, int> rightConsequences; // Swipe right consequences
  final String leftText;
  final String rightText;
  final String category;
  final int difficulty;

  Scenario({
    required this.id,
    required this.text,
    required this.leftConsequences,
    required this.rightConsequences,
    this.leftText = 'NO',
    this.rightText = 'YES',
    required this.category,
    this.difficulty = 1,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    return Scenario(
      id: json['id'],
      text: json['text'],
      leftConsequences: Map<String, int>.from(json['leftConsequences']),
      rightConsequences: Map<String, int>.from(json['rightConsequences']),
      leftText: json['leftText'] ?? 'NO',
      rightText: json['rightText'] ?? 'YES',
      category: json['category'],
      difficulty: json['difficulty'] ?? 1,
    );
  }
}
