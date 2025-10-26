class Appearance {
  final String gender;
  final String race;
  final List<String> height;
  final List<String> weight;
  final String eyeColor;
  final String hairColor;

  Appearance({
    required this.gender,
    required this.race,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hairColor,
  });

  factory Appearance.fromJson(Map<String, dynamic> json) {
    return Appearance(
      gender: json['gender'] ?? '',
      race: json['race'] ?? '',
      height: List<String>.from(json['height'] ?? []),
      weight: List<String>.from(json['weight'] ?? []),
      eyeColor: json['eye-color'] ?? '',
      hairColor: json['hair-color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'race': race,
      'height': height,
      'weight': weight,
      'eye-color': eyeColor,
      'hair-color': hairColor,
    };
  }
}