import 'dart:convert';
import 'dart:io';

import 'package:v04/config/constants.dart';
import 'package:v04/exceptions/api_exception.dart';
import 'package:v04/exceptions/data_persistence_exception.dart';
import 'package:v04/exceptions/validation_exception.dart';
import 'package:v04/handlers/http_handler.dart';
import 'package:v04/handlers/http_handler_interface.dart';
import 'package:v04/utils/error_handler.dart';

import '../models/heromodel.dart';
import 'hero_data_managing.dart';

class HeroDataManager implements HeroDataManaging {
  
  static HeroDataManager? _instance;

  final String _filePath;
  late List<HeroModel> _heroes;
  late final HttpHandlerInterface? _httpHandler;

  factory HeroDataManager() {
    // If _instance is null, create a new one. Otherwise, return the existing one.
    // This is essential for the singleton pattern.
    return _instance ??= HeroDataManager._internal();
  }

  HeroDataManager._internal() 
    : _filePath = 'heroes.json',
      _httpHandler = HttpHandler() {
    _heroes = [];
  }

  // Constructor for testing with dependency injection
  HeroDataManager.forTesting({
    String filePath = 'test_heroes.json',
    HttpHandlerInterface? httpHandler,
  }) : _filePath = filePath,
       _httpHandler = httpHandler {
    _heroes = [];
  }

  static void resetInstance() {
    _instance = null;
  }

  void clearHeroes() {
    _heroes.clear();
  }

  @override
  List<HeroModel> get heroes => _heroes;

  @override
  Future<bool> addHero(HeroModel hero) async {
    try {
      if (hero.name.trim().isEmpty) {
        throw ValidationException('Hero name cannot be empty', 'name');
      }

      if (hero.externalId != null && hero.externalId!.isNotEmpty) {
        final existingHero =
            _heroes.where((h) => h.externalId == hero.externalId).firstOrNull;
        if (existingHero != null) {
          throw ValidationException(
            'Hero with external ID ${hero.externalId} already exists',
            'externalId',
          );
        }
      }

      _heroes.add(hero);
      return await saveHeroes();
    } on ValidationException {
      rethrow;
    } catch (e) {
      final error = ErrorHandler.handleError(
        e,
        context: 'addHero',
        verbose: false,
      );
      throw error;
    }
  }

  @override
  Future<bool> deleteHero(String id) async {
    try {
      final initialLength = _heroes.length;
      _heroes.removeWhere((hero) => hero.id == id);
      
      if (_heroes.length < initialLength) {
        return await saveHeroes();
      }
      return false;
    } catch (e) {
      print('Error deleting hero: $e');
      return false;
    }
  }

  List<HeroModel> getHeroesSortedByStrength() {
    final sorted = List<HeroModel>.from(_heroes);
    sorted.sort((a, b) {
      final aStrength = int.tryParse(a.powerstats.strength) ?? 0;
      final bStrength = int.tryParse(b.powerstats.strength) ?? 0;
      return bStrength.compareTo(aStrength);
    });
    return sorted;
  }

  bool isExternalHeroAlreadySaved(String externalId) {
    if (externalId.isEmpty) return false;
    return _heroes.any((hero) => hero.externalId == externalId);
  }

  @override
  Future<void> loadHeroes() async {
    final file = File(_filePath);
    if (!file.existsSync()) {
      _heroes = [];
      return;
    }

    try {
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        _heroes = [];
        return;
      }

      final List<dynamic> jsonData = jsonDecode(content);
      _heroes = jsonData
          .map((json) => HeroModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading heroes: $e');
      _heroes = [];
    }
  }

@override
Future<bool> saveHeroes() async {
  try {
    final file = File(AppConstants.heroesFileName);
    final jsonData = jsonEncode(_heroes.map((hero) => hero.toJson()).toList());
    await file.writeAsString(jsonData);
    return true;
  } catch (e) {
    final error = ErrorHandler.handleError(
      e,
      context: 'saveHeroes',
      verbose: false,
    );
    throw DataPersistenceException(
      'Failed to save heroes: ${error.toString()}',
      e,
    );
  }
}
  
  @override
  Future<List<HeroModel>> searchHeroesByName(String heroName) async {
    if (_heroes.isEmpty) {
      return [];
    }

    final nameLowercase = heroName.toLowerCase().trim();
    return _heroes
        .where((hero) => hero.name.toLowerCase().contains(nameLowercase))
        .toList();
  }

  @override
  Future<List<HeroModel>> searchHeroesExternalByName(String name) async {

    if (name.trim().isEmpty) {
      throw ValidationException('Search query cannot be empty', 'name');
    }

    // null check with proper error handling
    if (_httpHandler == null) {
      throw UnsupportedError('External search not available - HttpHandler not initialized');
    }

    try {
      return await _httpHandler!.getHeroesByName(name, verbose: false);
    } on ValidationException {
      rethrow;
    } on ApiException {
      rethrow;
    } on HttpException {
      rethrow;
    } catch (e) {
      final error = ErrorHandler.handleError(
        e,
        context: 'searchHeroesExternalByName',
        verbose: false,
      );
      throw error;
    }
  }
}