import 'package:test/test.dart';
import 'package:v03/services/hero_data_manager.dart';

import '../common/test_data_factory.dart';

void main() {
  group('HeroDataManager Tests', () {
    late HeroDataManager manager;

    setUp(() {
      manager = HeroDataManager();
      manager.heroes.clear();
    });

    tearDown(() {
      manager.heroes.clear();
    });

    test('should add hero successfully', () async {
      final hero = TestDataFactory.createTestHero();
      final result = await manager.addHero(hero);
      
      expect(result, isTrue);
      expect(manager.heroes.length, 1);
      expect(manager.heroes.first.name, hero.name);
    });

    test('should search heroes by name', () async {
      final hero1 = TestDataFactory.createTestHero(name: 'Spider-Man');
      final hero2 = TestDataFactory.createTestHero(name: 'Batman');
      
      await manager.addHero(hero1);
      await manager.addHero(hero2);
      
      final results = await manager.searchHeroesByName('spider');
      
      expect(results.length, 1);
      expect(results.first.name, 'Spider-Man');
    });

    test('should handle multiple heroes with different strengths', () async {
      final heroes = TestDataFactory.createMultipleTestHeroes(3);
      
      for (final hero in heroes) {
        await manager.addHero(hero);
      }
      
      expect(manager.heroes.length, 3);
    });
  });
}