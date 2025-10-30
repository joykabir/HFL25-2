import '../models/heromodel.dart';

abstract class HeroDataManaging {
  List<HeroModel> get heroes;
  
  Future<bool> addHero(HeroModel hero);
  Future<bool> deleteHero(String id);
  Future<void> loadHeroes();
  Future<bool> saveHeroes();
  Future<List<HeroModel>> searchExternalHeroes(String name);
  Future<List<HeroModel>> searchHeroesByName(String name);
}