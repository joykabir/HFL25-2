import '../models/heromodel.dart';

abstract class HeroDataManaging {
  List<HeroModel> get heroes;
  
  void addHero(HeroModel hero);
  void deleteHero(String id);
  void loadHeroes();
  void saveHeroes();
  List<HeroModel> searchHeroesByName(String name);
}