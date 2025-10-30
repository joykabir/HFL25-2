import '../models/heromodel.dart';

abstract class HttpHandlerInterface {
  Future<List<HeroModel>> getHeroesByName(String name, {bool verbose = false});
  Future<HeroModel?> getHeroDetailsById(String externalId, {bool verbose = false});
  Future<bool> testConnection({bool verbose = false});
}