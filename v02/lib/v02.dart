import 'dart:convert';
import 'dart:io';

import 'hero.dart';

const String heroesFile = 'heroes.json';
int _nextId = 1;

// Add a new hero
void addHero(List<Hero> heroes) {
  print('\n➕ Adding a new hero...');

  stdout.write('Enter hero name: ');
  final name = stdin.readLineSync() ?? '';

  int strength = 0;
  while (true) {
    stdout.write('Enter strength (integer): ');
    final strengthInput = stdin.readLineSync();
    final parsed = int.tryParse(strengthInput ?? '');
    if (parsed != null) {
      strength = parsed;
      break;
    } else {
      print('❌ Please enter a valid integer.');
    }
  }

  stdout.write('Enter special power (optional): ');
  final specialPower = stdin.readLineSync() ?? '';

  stdout.write('Enter gender (optional): ');
  final gender = stdin.readLineSync() ?? '';

  stdout.write('Enter race (optional): ');
  final race = stdin.readLineSync() ?? '';

  stdout.write('Enter alignment (good/evil, optional): ');
  final alignment = stdin.readLineSync() ?? '';

  // Create Hero object
  final hero = Hero(
    id: _nextId++,
    name: name.isEmpty ? 'Unknown Hero' : name,
    powerstats: Powerstats(strength: strength),
    appearance: Appearance(gender: gender, race: race),
    biography: Biography(alignment: alignment),
    specialPower: specialPower.isEmpty ? null : specialPower,
  );

  heroes.add(hero);
  print('\n✅ Hero "${hero.name}" added successfully!\n');
}

// Keep the original calculate function for backwards compatibility
int calculate() {
  return 6 * 7;
}

// Load heroes from JSON file
List<Hero> loadHeroes() {
  final file = File(heroesFile);

  if (!file.existsSync()) {
    return [];
  }

  try {
    final content = file.readAsStringSync();
    if (content.trim().isEmpty) {
      return [];
    }

    final List<dynamic> jsonData = jsonDecode(content);
    final heroes = jsonData
        .map((json) => Hero.fromJson(json as Map<String, dynamic>))
        .toList();

    // Update _nextId to be higher than any existing ID
    if (heroes.isNotEmpty) {
      final maxId = heroes.map((h) => h.id).reduce((a, b) => a > b ? a : b);
      _nextId = maxId + 1;
    }

    return heroes;
  } catch (e) {
    print('⚠️  Error loading heroes: $e');
    return [];
  }
}

void printMenu() {
  print('─────────────────────────────────────');
  print('  MENU:');
  print('  1. Add hero');
  print('  2. Show heroes');
  print('  3. Search heroes');
  print('  4. Exit');
  print('─────────────────────────────────────');
}

void saveHeroesToJson(List<Hero> heroes) {
  try {
    final file = File(heroesFile);
    final jsonData = jsonEncode(heroes.map((hero) => hero.toJson()).toList());
    file.writeAsStringSync(jsonData);
  } catch (e) {
    print('⚠️  Error saving heroes: $e');
  }
}

// Search heroes by name
void searchHeroes(List<Hero> heroes) {
  if (heroes.isEmpty) {
    print('\n📭 No heroes to search.\n');
    return;
  }

  stdout.write('\n🔍 Enter name or letter to search: ');
  final query = (stdin.readLineSync() ?? '').toLowerCase().trim();

  if (query.isEmpty) {
    print('❌ Search query cannot be empty.\n');
    return;
  }

  final matches = heroes.where((hero) {
    return hero.name.toLowerCase().contains(query);
  }).toList();

  if (matches.isEmpty) {
    print('\n❌ No heroes found matching "$query".\n');
  } else {
    print('\n✅ Found ${matches.length} hero(es) matching "$query":');
    print('─────────────────────────────────────');
    for (var hero in matches) {
      _printHero(hero);
    }
    print('─────────────────────────────────────\n');
  }
}

// Show all heroes sorted by strength (strongest first)
void showHeroes(List<Hero> heroes) {
  if (heroes.isEmpty) {
    print('\n📭 No heroes in the database yet.\n');
    return;
  }

  // Sort by strength (strongest first)
  final sortedHeroes = List<Hero>.from(heroes);
  sortedHeroes
      .sort((a, b) => b.powerstats.strength.compareTo(a.powerstats.strength));

  print('\n🦸 ALL HEROES (sorted by strength):');
  print('═══════════════════════════════════════');

  // Use forEach to print the list
  for (var hero in sortedHeroes) {
    _printHero(hero);
  }

  print('═══════════════════════════════════════\n');
}

// Helper: Print a single hero
void _printHero(Hero hero) {
  final specialPowerDisplay = hero.specialPower ?? 'None';

  print('  ID: ${hero.id} | Name: ${hero.name}');
  print('    💪 Strength: ${hero.powerstats.strength}');
  print('    ⚔️  Special Power: $specialPowerDisplay');
  print(
      '    👤 Gender: ${hero.appearance.gender} | Race: ${hero.appearance.race}');
  print('    ⚖️  Alignment: ${hero.biography.alignment}');
  print('');
}
