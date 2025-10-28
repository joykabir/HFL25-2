import 'dart:convert';
import 'dart:io';

import '../models/heromodel.dart';
import 'hero_data_managing.dart';

class HeroDataManager implements HeroDataManaging {
  static final HeroDataManager _instance = HeroDataManager._internal();
  
  final String _filePath = 'heroes.json';
  late List<HeroModel> _heroes;

  factory HeroDataManager() {
    return _instance;
  }

  HeroDataManager._internal() {
    _heroes = [];
  }

  @override
  List<HeroModel> get heroes => _heroes;

  @override
  void addHero(HeroModel hero) {
    _heroes.add(hero);
  }

  @override
  void deleteHero(String id) {
    _heroes.removeWhere((hero) => hero.id == id);
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

  @override
  void loadHeroes() {
    final file = File(_filePath);

    if (!file.existsSync()) {
      _heroes = [];
      return;
    }

    try {
      final content = file.readAsStringSync();
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
  void saveHeroes() {
    try {
      final file = File(_filePath);
      final jsonData = jsonEncode(_heroes.map((hero) => hero.toJson()).toList());
      file.writeAsStringSync(jsonData);
    } catch (e) {
      print('Error saving heroes: $e');
    }
  }

  @override
  List<HeroModel> searchHeroesByName(String query) {
    if (_heroes.isEmpty) {
      return [];
    }

    final lowerQuery = query.toLowerCase().trim();
    return _heroes
        .where((hero) => hero.name.toLowerCase().contains(lowerQuery))
        .toList();
  }
}