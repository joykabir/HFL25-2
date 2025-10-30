import 'dart:convert';
import 'dart:io';

import '../models/heromodel.dart';
import '../network/http_handler.dart';
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
  Future<bool> addHero(HeroModel hero) async {
    try {
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
  Future<List<HeroModel>> searchExternalHeroes(String name) {
    throw UnimplementedError();
  }
  
  @override
  Future<List<HeroModel>> searchHeroesByName(String name) async {
    if (_heroes.isEmpty) {
      return [];
    }

    final nameLowercase = name.toLowerCase().trim();
    return _heroes
        .where((hero) => hero.name.toLowerCase().contains(nameLowercase))
        .toList();
  }
}