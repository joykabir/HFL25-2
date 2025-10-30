class Work {
  final String occupation;
  final String base;

  Work({
    required this.occupation,
    required this.base,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      occupation: json['occupation'] ?? '',
      base: json['base'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'occupation': occupation,
      'base': base,
    };
  }
}