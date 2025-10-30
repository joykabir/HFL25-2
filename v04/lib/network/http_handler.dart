import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:v04/config/app_config.dart';

import '../models/appearance.dart';
import '../models/biography.dart';
import '../models/connections.dart';
import '../models/heroimage.dart';
import '../models/heromodel.dart';
import '../models/powerstats.dart';
import '../models/work.dart';

// My custom exception for HTTP errors
class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  
  @override
  String toString() => 'HttpException: $message';
}

class HttpHandler {
  static final HttpHandler _instance = HttpHandler._internal();
  late final String _baseUrl;
  late final String _apiKey;

  factory HttpHandler() {
    return _instance;
  }

  HttpHandler._internal() {
    final config = AppConfig.instance;
    _baseUrl = config.apiUrl;
    _apiKey = config.apiKey;
  }


  /// Fetches detailed hero information by external API ID.
  Future<HeroModel?> getHeroDetailsById(String externalId) async {
    if (externalId.trim().isEmpty) {
      throw ArgumentError('Hero ID cannot be empty');
    }

    final url = _buildApiUrl(externalId.trim());

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['response'] == 'success') {
          return _convertApiResponseToHeroModel(data);
        } else {
          print('API Error: ${data['error'] ?? 'Unknown error'}');
          return null;
        }
      } else if (response.statusCode == 404) {
        print('Hero not found with ID: $externalId');
        return null;
      } else {
        throw HttpException('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on FormatException catch (e) {
      throw HttpException('Invalid JSON response: $e');
    } on http.ClientException catch (e) {
      throw HttpException('Network error: $e');
    } catch (e) {
      throw HttpException('Unexpected error: $e');
    }
  }

  /// Fetches superhero data from the API based on the provided name.
  Future<List<HeroModel>> getHeroesByName(String name) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Hero name cannot be empty');
    }

    final searchEndpoint = 'search/${Uri.encodeComponent(name.trim())}';
    final url = _buildApiUrl(searchEndpoint);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Check API response status
        if (data['response'] == 'error') {
          print('API Error: ${data['error'] ?? 'Unknown error'}');
          return [];
        }

        if (data['response'] == 'success' && data.containsKey('results')) {
          final List<dynamic> results = data['results'];

          if (results.isEmpty) {
            print('No heroes found with the name: $name');
            return [];
          }

          return results.map((heroJson) => _convertApiResponseToHeroModel(heroJson)).toList();
        } else {
          print('Unexpected API response structure for name: $name');
          return [];
        }
      } else if (response.statusCode == 404) {
        print('No heroes found with the name: $name');
        return [];
      } else {
        throw HttpException('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on FormatException catch (e) {
      throw HttpException('Invalid JSON response: $e');
    } on http.ClientException catch (e) {
      throw HttpException('Network error: $e');
    } catch (e) {
      throw HttpException('Unexpected error: $e');
    }
  }

  /// Tests the API connection just for verification purposes
Future<bool> testConnection({bool verbose = false}) async {
  try {
    if (verbose) {
      print('Testing API connection...');
      print('URL: $_baseUrl');
      print('API Key: ${_apiKey.substring(0, 5)}...${_apiKey.substring(_apiKey.length - 5)}');
    }

    final heroes = await getHeroesByName('batman');
    
    if (heroes.isNotEmpty) {
      if (verbose) {
        print('[TEST] ✅ Connection successful!');
        print('[TEST] Retrieved ${heroes.length} hero(es) from API');
      }
      return true;
    } else {
      if (verbose) {
        print('[TEST] ⚠️  Connection OK but no heroes returned');
      }
      return false;
    }
  } catch (e) {
    if (verbose) {
      print('[TEST] ❌ Connection failed: $e');
    }
    return false;
  }
}

  /// Builds the complete API URL for a specific endpoint.
  String _buildApiUrl(String endpoint) {
    return '$_baseUrl/$_apiKey/$endpoint';
  }

  /// Converts API response JSON to HeroModel with proper field mapping.
  HeroModel _convertApiResponseToHeroModel(Map<String, dynamic> json) {
    return HeroModel(
      externalId: json['id']?.toString(),
      name: json['name'] ?? 'Unknown Hero',
      powerstats: Powerstats(
        intelligence: _safeStringValue(json['powerstats']?['intelligence']),
        strength: _safeStringValue(json['powerstats']?['strength']),
        speed: _safeStringValue(json['powerstats']?['speed']),
        durability: _safeStringValue(json['powerstats']?['durability']),
        power: _safeStringValue(json['powerstats']?['power']),
        combat: _safeStringValue(json['powerstats']?['combat']),
      ),
      biography: Biography(
        fullName: json['biography']?['full-name'] ?? '',
        alterEgos: json['biography']?['alter-egos'] ?? '',
        aliases: _safeStringList(json['biography']?['aliases']),
        placeOfBirth: json['biography']?['place-of-birth'] ?? '',
        firstAppearance: json['biography']?['first-appearance'] ?? '',
        publisher: json['biography']?['publisher'] ?? '',
        alignment: json['biography']?['alignment'] ?? '',
      ),
      appearance: Appearance(
        gender: json['appearance']?['gender'] ?? '',
        race: json['appearance']?['race'] ?? '',
        height: _safeStringList(json['appearance']?['height']),
        weight: _safeStringList(json['appearance']?['weight']),
        eyeColor: json['appearance']?['eye-color'] ?? '',
        hairColor: json['appearance']?['hair-color'] ?? '',
      ),
      work: Work(
        occupation: json['work']?['occupation'] ?? '',
        base: json['work']?['base'] ?? '',
      ),
      connections: Connections(
        groupAffiliation: json['connections']?['group-affiliation'] ?? '',
        relatives: json['connections']?['relatives'] ?? '',
      ),
      image: HeroImage(
        url: json['image']?['url'] ?? '',
      ),
    );
  }

  /// Safely converts dynamic value to List<String>, handling null and various formats.
  List<String> _safeStringList(dynamic value) {
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

/// Safely converts dynamic value to string, handling null and 'null' string.
  String _safeStringValue(dynamic value) {
    if (value == null || value == 'null' || value == '-') {
      return '0';
    }
    return value.toString();
  }
}