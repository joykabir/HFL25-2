import 'package:test/test.dart';
import 'package:v02/hero.dart';

void main() {
  group('Hero Class Tests', () {
    
    test('Test 1: Hero object can be created with all fields', () {
      final hero = Hero(
        id: 1,
        name: 'Batman',
        powerstats: Powerstats(strength: 75),
        appearance: Appearance(gender: 'Male', race: 'Human'),
        biography: Biography(alignment: 'good'),
        specialPower: 'Gadgets',
      );

      expect(hero.id, equals(1));
      expect(hero.name, equals('Batman'));
      expect(hero.powerstats.strength, equals(75));
      expect(hero.appearance.gender, equals('Male'));
      expect(hero.biography.alignment, equals('good'));
      expect(hero.specialPower, equals('Gadgets'));
    });

    test('Test 2: Hero can be serialized to JSON', () {
      final hero = Hero(
        id: 2,
        name: 'Superman',
        powerstats: Powerstats(strength: 100),
        appearance: Appearance(gender: 'Male', race: 'Kryptonian'),
        biography: Biography(alignment: 'good'),
        specialPower: 'Flight',
      );

      final json = hero.toJson();

      expect(json['id'], equals(2));
      expect(json['name'], equals('Superman'));
      expect(json['powerstats']['strength'], equals('100'));
      expect(json['appearance']['gender'], equals('Male'));
      expect(json['biography']['alignment'], equals('good'));
      expect(json['specialPower'], equals('Flight'));
    });

    test('Test 3: Hero can be deserialized from JSON', () {
      final json = {
        'id': 3,
        'name': 'Wonder Woman',
        'powerstats': {'strength': '95'},
        'appearance': {'gender': 'Female', 'race': 'Amazonian'},
        'biography': {'alignment': 'good'},
        'specialPower': 'Lasso of Truth',
      };

      final hero = Hero.fromJson(json);

      expect(hero.id, equals(3));
      expect(hero.name, equals('Wonder Woman'));
      expect(hero.powerstats.strength, equals(95));
      expect(hero.appearance.gender, equals('Female'));
      expect(hero.biography.alignment, equals('good'));
      expect(hero.specialPower, equals('Lasso of Truth'));
    });

    test('Test 4: Heroes list can be sorted by strength', () {
      final heroes = [
        Hero(
          id: 1,
          name: 'Weak Hero',
          powerstats: Powerstats(strength: 10),
          appearance: Appearance(gender: 'Male', race: 'Human'),
          biography: Biography(alignment: 'good'),
        ),
        Hero(
          id: 2,
          name: 'Strong Hero',
          powerstats: Powerstats(strength: 90),
          appearance: Appearance(gender: 'Female', race: 'Mutant'),
          biography: Biography(alignment: 'good'),
        ),
        Hero(
          id: 3,
          name: 'Medium Hero',
          powerstats: Powerstats(strength: 50),
          appearance: Appearance(gender: 'Male', race: 'Human'),
          biography: Biography(alignment: 'neutral'),
        ),
      ];

      heroes.sort((a, b) => b.powerstats.strength.compareTo(a.powerstats.strength));

      expect(heroes[0].name, equals('Strong Hero'));
      expect(heroes[1].name, equals('Medium Hero'));
      expect(heroes[2].name, equals('Weak Hero'));
    });

    test('Test 5: Search finds heroes by name', () {
      final heroes = [
        Hero(
          id: 1,
          name: 'Batman',
          powerstats: Powerstats(strength: 75),
          appearance: Appearance(gender: 'Male', race: 'Human'),
          biography: Biography(alignment: 'good'),
        ),
        Hero(
          id: 2,
          name: 'Superman',
          powerstats: Powerstats(strength: 100),
          appearance: Appearance(gender: 'Male', race: 'Kryptonian'),
          biography: Biography(alignment: 'good'),
        ),
        Hero(
          id: 3,
          name: 'Batgirl',
          powerstats: Powerstats(strength: 60),
          appearance: Appearance(gender: 'Female', race: 'Human'),
          biography: Biography(alignment: 'good'),
        ),
      ];

      final searchQuery = 'bat';
      final matches = heroes.where((hero) {
        return hero.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      expect(matches.length, equals(2));
      expect(matches[0].name, equals('Batman'));
      expect(matches[1].name, equals('Batgirl'));
    });
  });
}