import 'package:uuid/uuid.dart';

class Appearance {
  final String gender;
  final String race;

  Appearance({required this.gender, required this.race});

  factory Appearance.fromJson(Map<String, dynamic> json) {
    return Appearance(
      gender: json['gender'] as String? ?? '',
      race: json['race'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'race': race,
    };
  }
}

class Biography {
  final String alignment;

  Biography({required this.alignment});

  factory Biography.fromJson(Map<String, dynamic> json) {
    return Biography(
      alignment: json['alignment'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'alignment': alignment};
  }
}

class Hero {
  final String id;
  final String name;
  final Powerstats powerstats;
  final Appearance appearance;
  final Biography biography;
  final String? specialPower;

  Hero({
    String? id,  // Make it optional, generate if not provided
    required this.name,
    required this.powerstats,
    required this.appearance,
    required this.biography,
    this.specialPower,
  }) : id = id ?? _generateId();  // Auto-generate UUID if not provided

  // Deserialize JSON to Hero
  factory Hero.fromJson(Map<String, dynamic> json) {
    return Hero(
      id: json['id'] as String,
      name: json['name'] as String,
      powerstats: Powerstats.fromJson(json['powerstats'] as Map<String, dynamic>),
      appearance: Appearance.fromJson(json['appearance'] as Map<String, dynamic>),
      biography: Biography.fromJson(json['biography'] as Map<String, dynamic>),
      specialPower: json['specialPower'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'name': name,
      'powerstats': powerstats.toJson(),
      'appearance': appearance.toJson(),
      'biography': biography.toJson(),
    };
    
    if (specialPower != null && specialPower!.isNotEmpty) {
      json['specialPower'] = specialPower!;
    }
    
    return json;
  }

  @override
  String toString() {
    return 'Hero{id: $id, name: $name, strength: ${powerstats.strength}}';
  }

  // Generate a unique UUID
  static String _generateId() {
    const uuid = Uuid();
    return uuid.v4();  // Generates UUID v4
  }
}

class Powerstats {
  final int strength;

  Powerstats({required this.strength});

  factory Powerstats.fromJson(Map<String, dynamic> json) {
    final strengthValue = json['strength'];
    int strength = 0;
    
    if (strengthValue is int) {
      strength = strengthValue;
    } else if (strengthValue is String) {
      strength = int.tryParse(strengthValue) ?? 0;
    }
    
    return Powerstats(strength: strength);
  }

  Map<String, dynamic> toJson() {
    return {'strength': strength.toString()};
  }
}