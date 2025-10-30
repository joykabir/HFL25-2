import 'dart:convert';
import 'dart:io';

import 'package:v04/network/http_handler.dart';

import '../models/heromodel.dart';
import 'hero_data_managing.dart';

class HeroDataManager implements HeroDataManaging {
  
  static final HeroDataManager _instance = HeroDataManager._internal();
  
  final String _filePath = 'heroes.json';
  late List<HeroModel> _heroes;
  late final HttpHandler _httpHandler;

  factory HeroDataManager() {
    return _instance;
  }

  HeroDataManager._internal() {
    _heroes = [];
    _httpHandler = HttpHandler();
  }

  @override
  List<HeroModel> get heroes => _heroes;

  @override
  Future<bool> addHero(HeroModel hero) async {
    try {
      if (hero.externalId != null && hero.externalId!.isNotEmpty) {
        final existingHero = _heroes.where((h) => h.externalId == hero.externalId).firstOrNull;
        if (existingHero != null) {
          print('❌ Hero with external ID ${hero.externalId} already exists: ${existingHero.name}');
          return false;
        }
      }

      _heroes.add(hero);
      return await saveHeroes();
    } catch (e) {
      print('Error adding hero: $e');
      return false;
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
  Future<bool> saveHeroes() async{
    try {
      final file = File(_filePath);
      final jsonData = jsonEncode(_heroes.map((hero) => hero.toJson()).toList());
      await file.writeAsString(jsonData);
      return true;
    } catch (e) {
      print('Error saving heroes: $e');
      return false;
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
  Future<List<HeroModel>> searchHeroesExternalByName(String name) async{
    try {

      return await _httpHandler.getHeroesByName(name);
    } catch (e) {
      print('Error searching heroes externally: $e');
      return Future.value([]);
    }
  }
}