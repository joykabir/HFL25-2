import 'dart:io';

import 'package:test/test.dart';
import 'package:v04/exceptions/validation_exception.dart';
import 'package:v04/models/heromodel.dart';
import 'package:v04/services/hero_data_manager.dart';

import '../common/mock_http_handler.dart';
import '../common/test_data_factory.dart';

void main() {
  group('HeroDataManager Tests', () {
    late HeroDataManager manager;
    late MockHttpHandler mockHttpHandler;
    final testFilePath = 'test_heroes_${DateTime.now().millisecondsSinceEpoch}.json';

    setUp(() {
      HeroDataManager.resetInstance();
      
      mockHttpHandler = MockHttpHandler();
      
      // Create manager for testing with dependency injection
      manager = HeroDataManager.forTesting(
        filePath: testFilePath,
        httpHandler: mockHttpHandler,
      );
    });

    tearDown(() async {
      manager.heroes.clear();

      final testFile = File(testFilePath);
      if (await testFile.exists()) {
        await testFile.delete();
      }
    });

    test('should add hero successfully', () async {
      final hero = TestDataFactory.createTestHero();
      final result = await manager.addHero(hero);
      
      expect(result, isTrue);
      expect(manager.heroes.length, 1);
      expect(manager.heroes.first.name, hero.name);
    });

    test('should search local heroes by name', () async {
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
      
      final sortedHeroes = manager.getHeroesSortedByStrength();
      expect(sortedHeroes.length, 3);
      
      final strengths = sortedHeroes.map((h) => int.tryParse(h.powerstats.strength) ?? 0).toList();
      expect(strengths, equals(strengths.toList()..sort((a, b) => b.compareTo(a))));
    });

    test('should delete hero successfully', () async {
      final hero = TestDataFactory.createTestHero();
      await manager.addHero(hero);
      
      expect(manager.heroes.length, 1);
      
      final result = await manager.deleteHero(hero.id);
      
      expect(result, isTrue);
      expect(manager.heroes.length, 0);
    });

    test('should prevent duplicate external heroes', () async {
      final hero1 = TestDataFactory.createTestHero(name: 'Superman');
      final hero2 = TestDataFactory.createTestHero(name: 'Superman Clone');
      
      // Set same external ID
      final heroWithExternalId1 = HeroModel(
        externalId: 'ext_123',
        name: hero1.name,
        powerstats: hero1.powerstats,
        biography: hero1.biography,
        appearance: hero1.appearance,
        work: hero1.work,
        connections: hero1.connections,
        image: hero1.image,
      );
      
      final heroWithExternalId2 = HeroModel(
        externalId: 'ext_123', // Same external ID
        name: hero2.name,
        powerstats: hero2.powerstats,
        biography: hero2.biography,
        appearance: hero2.appearance,
        work: hero2.work,
        connections: hero2.connections,
        image: hero2.image,
      );
      
      final result1 = await manager.addHero(heroWithExternalId1);
      expect(result1, isTrue);
      expect(manager.heroes.length, 1);
      
      // Try to add duplicate
      expect(
        () async => await manager.addHero(heroWithExternalId2),
        throwsA(isA<ValidationException>()),
      );
      expect(manager.heroes.length, 1);
    });

    test('should search external heroes via mock API', () async {
      // Setup mock data
      final mockHero = TestDataFactory.createTestHero(name: 'Mock Superman');
      mockHttpHandler.addMockResult(mockHero);
      
      final results = await manager.searchHeroesExternalByName('superman');
      
      expect(results.length, 1);
      expect(results.first.name, 'Mock Superman');
    });

    test('should handle external API errors gracefully', () async {
      mockHttpHandler.setShouldThrowError(true);
      
      expect(
        () async => await manager.searchHeroesExternalByName('batman'),
        throwsA(isA<Exception>()),
      );
    });

    test('should check if external hero is already saved', () {
      final hero = TestDataFactory.createTestHero();
      final heroWithExternalId = HeroModel(
        externalId: 'ext_456',
        name: hero.name,
        powerstats: hero.powerstats,
        biography: hero.biography,
        appearance: hero.appearance,
        work: hero.work,
        connections: hero.connections,
        image: hero.image,
      );
      
      // Before adding
      expect(manager.isExternalHeroAlreadySaved('ext_456'), isFalse);
      
      // Add hero
      manager.heroes.add(heroWithExternalId);
      
      // After adding
      expect(manager.isExternalHeroAlreadySaved('ext_456'), isTrue);
      expect(manager.isExternalHeroAlreadySaved('ext_999'), isFalse);
    });

    test('should load and save heroes to file', () async {
      final hero = TestDataFactory.createTestHero();
      await manager.addHero(hero);
      
      final newManager = HeroDataManager.forTesting(
        filePath: testFilePath,
        httpHandler: mockHttpHandler,
      );
      await newManager.loadHeroes();
      
      expect(newManager.heroes.length, 1);
      expect(newManager.heroes.first.name, hero.name);
    });
  });
  
}