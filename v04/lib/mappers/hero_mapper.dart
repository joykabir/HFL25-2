

/// Mapper for converting external API responses to HeroModel compatible format
class HeroMapper {
  static Map<String, dynamic> fromApiJson(Map<String, dynamic> apiJson) {
    return {
      'external_id': apiJson['id']?.toString(),
      'name': apiJson['name'] ?? 'Unknown Hero',
      'powerstats': _mapPowerstats(apiJson['powerstats']),
      'biography': _mapBiography(apiJson['biography']),
      'appearance': _mapAppearance(apiJson['appearance']),
      'work': _mapWork(apiJson['work']),
      'connections': _mapConnections(apiJson['connections']),
      'image': _mapImage(apiJson['image']),
    };
  }

  static Map<String, dynamic> _mapAppearance(Map<String, dynamic>? json) {
    if (json == null) {
      return {
        'gender': '',
        'race': '',
        'height': [],
        'weight': [],
        'eye_color': '',
        'hair_color': '',
      };
    }

    return {
      'gender': json['gender'] ?? '',
      'race': json['race'] ?? '',
      'height': _safeStringList(json['height']),
      'weight': _safeStringList(json['weight']),
      'eye_color': json['eye-color'] ?? '',
      'hair_color': json['hair-color'] ?? '',
    };
  }

  static Map<String, dynamic> _mapBiography(Map<String, dynamic>? json) {
    if (json == null) {
      return {
        'full_name': '',
        'alter_egos': '',
        'aliases': [],
        'place_of_birth': '',
        'first_appearance': '',
        'publisher': '',
        'alignment': '',
      };
    }

    return {
      'full_name': json['full-name'] ?? '',
      'alter_egos': json['alter-egos'] ?? '',
      'aliases': _safeStringList(json['aliases']),
      'place_of_birth': json['place-of-birth'] ?? '',
      'first_appearance': json['first-appearance'] ?? '',
      'publisher': json['publisher'] ?? '',
      'alignment': json['alignment'] ?? '',
    };
  }


  static Map<String, dynamic> _mapConnections(Map<String, dynamic>? json) {
    if (json == null) {
      return {
        'group_affiliation': '',
        'relatives': '',
      };
    }

    return {
      'group_affiliation': json['group-affiliation'] ?? '',
      'relatives': json['relatives'] ?? '',
    };
  }


  static Map<String, dynamic> _mapImage(Map<String, dynamic>? json) {
    if (json == null) {
      return {'url': ''};
    }

    return {
      'url': json['url'] ?? '',
    };
  }


  static Map<String, dynamic> _mapPowerstats(Map<String, dynamic>? json) {
    if (json == null) {
      return {
        'intelligence': '0',
        'strength': '0',
        'speed': '0',
        'durability': '0',
        'power': '0',
        'combat': '0',
      };
    }

    return {
      'intelligence': _safeStringValue(json['intelligence']),
      'strength': _safeStringValue(json['strength']),
      'speed': _safeStringValue(json['speed']),
      'durability': _safeStringValue(json['durability']),
      'power': _safeStringValue(json['power']),
      'combat': _safeStringValue(json['combat']),
    };
  }

  static Map<String, dynamic> _mapWork(Map<String, dynamic>? json) {
    if (json == null) {
      return {
        'occupation': '',
        'base': '',
      };
    }

    return {
      'occupation': json['occupation'] ?? '',
      'base': json['base'] ?? '',
    };
  }

  static List<String> _safeStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String) {
      if (value.isEmpty || value == 'null' || value == '-') return [];
      return [value];
    }
    return [value.toString()];
  }

  /// Safely convert dynamic value to string, handling null and 'null' string
  static String _safeStringValue(dynamic value) {
    if (value == null || value == 'null' || value == '-') {
      return '0';
    }
    return value.toString();
  }
}