import 'package:test/test.dart';
import 'package:v03/models/heromodel.dart';

import '../common/mock_hero_data_manager.dart';
import '../common/test_data_factory.dart';

void main() {
  group('HeroModel Tests', () {
    test('should create HeroModel with all fields', () {
      final hero = TestDataFactory.createTestHero(
        name: 'Test Hero',
        intelligence: '90',
        strength: '80',
        speed: '70',
        durability: '60',
        power: '50',
        combat: '40',
      );

      expect(hero.name, 'Test Hero');
      expect(hero.powerstats.intelligence, '90');
      expect(hero.powerstats.strength, '80');
      expect(hero.biography.fullName, 'Test Hero Full Name');
      expect(hero.appearance.gender, 'Male');
      expect(hero.work.occupation, 'Software Developer, Hero');
      expect(hero.connections.groupAffiliation, 'Test Team, Justice League');
    });

    test('should create empty HeroModel for validation testing', () {
      final hero = TestDataFactory.createEmptyHero();

      expect(hero.name, '');
      expect(hero.powerstats.intelligence, '');
      expect(hero.biography.fullName, '');
      expect(hero.appearance.gender, '');
      expect(hero.work.occupation, '');
    });

    test('should create multiple heroes with different strengths', () {
      final heroes = TestDataFactory.createMultipleTestHeroes(3);

      expect(heroes.length, 3);
      expect(heroes[0].name, 'Test Hero 1');
      expect(heroes[1].name, 'Test Hero 2');
      expect(heroes[2].name, 'Test Hero 3');
      
      // Test strength progression
      expect(heroes[0].powerstats.strength, '50');
      expect(heroes[1].powerstats.strength, '60');
      expect(heroes[2].powerstats.strength, '70');
    });

    test('should create hero with specific publisher', () {
      final marvelHero = TestDataFactory.createMarvelHero('Spider-Man');
      final dcHero = TestDataFactory.createDCHero('Batman');

      expect(marvelHero.name, 'Spider-Man');
      expect(marvelHero.biography.publisher, 'Marvel Comics');
      
      expect(dcHero.name, 'Batman');
      expect(dcHero.biography.publisher, 'DC Comics');
    });

    test('should convert to and from JSON', () {
      final originalHero = TestDataFactory.createTestHero();
      
      // Convert to JSON
      final json = originalHero.toJson();
      
      // Convert back from JSON
      final reconstructedHero = HeroModel.fromJson(json);
      
      // Verify all fields match
      expect(reconstructedHero.name, originalHero.name);
      expect(reconstructedHero.powerstats.intelligence, originalHero.powerstats.intelligence);
      expect(reconstructedHero.biography.fullName, originalHero.biography.fullName);
      expect(reconstructedHero.appearance.gender, originalHero.appearance.gender);
      expect(reconstructedHero.work.occupation, originalHero.work.occupation);
      expect(reconstructedHero.connections.groupAffiliation, originalHero.connections.groupAffiliation);
      expect(reconstructedHero.image.url, originalHero.image.url);
    });

    test('should handle JSON serialization of mock heroes', () {
      final mockManager = MockHeroDataManager();
      final batman = mockManager.heroes.firstWhere((h) => h.name == 'Batman');

      // Serialize to JSON
      final json = batman.toJson();
      expect(json['name'], 'Batman');
      expect(json['biography']['full-name'], 'Bruce Wayne');

      // Deserialize back
      final reconstructed = HeroModel.fromJson(json);
      expect(reconstructed.name, batman.name);
      expect(reconstructed.biography.fullName, batman.biography.fullName);
      expect(reconstructed.powerstats.intelligence, batman.powerstats.intelligence);
    });
  });
}