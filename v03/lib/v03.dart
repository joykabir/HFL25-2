import 'dart:io';

import 'models/appearance.dart';
import 'models/biography.dart';
import 'models/connections.dart';
import 'models/heroimage.dart';
import 'models/heromodel.dart';
import 'models/powerstats.dart';
import 'models/work.dart';
import 'services/hero_data_manager.dart';

// Add a new hero (interactive)
void addHeroInteractive(HeroDataManager heroDataManager) {
  print('\nAdding a new hero...');

  stdout.write('Enter hero name: ');
  final name = stdin.readLineSync() ?? '';

  if (name.isEmpty) {
    print('Please enter a valid name.\n');
    return;
  }

  // Powerstats
  stdout.write('Enter intelligence (0-100): ');
  final intelligence = stdin.readLineSync() ?? '0';

  stdout.write('Enter strength (0-100): ');
  final strength = stdin.readLineSync() ?? '0';

  stdout.write('Enter speed (0-100): ');
  final speed = stdin.readLineSync() ?? '0';

  stdout.write('Enter durability (0-100): ');
  final durability = stdin.readLineSync() ?? '0';

  stdout.write('Enter power (0-100): ');
  final power = stdin.readLineSync() ?? '0';

  stdout.write('Enter combat (0-100): ');
  final combat = stdin.readLineSync() ?? '0';

  // Biography
  stdout.write('Enter full name (optional): ');
  final fullName = stdin.readLineSync() ?? '';

  stdout.write('Enter alter egos (optional): ');
  final alterEgos = stdin.readLineSync() ?? '';

  stdout.write('Enter alignment (good/evil, optional): ');
  final alignment = stdin.readLineSync() ?? '';

  stdout.write('Enter first appearance (optional): ');
  final firstAppearance = stdin.readLineSync() ?? '';

  stdout.write('Enter publisher (optional): ');
  final publisher = stdin.readLineSync() ?? '';

  // Appearance
  stdout.write('Enter gender (optional): ');
  final gender = stdin.readLineSync() ?? '';

  stdout.write('Enter race (optional): ');
  final race = stdin.readLineSync() ?? '';

  stdout.write('Enter eye color (optional): ');
  final eyeColor = stdin.readLineSync() ?? '';

  stdout.write('Enter hair color (optional): ');
  final hairColor = stdin.readLineSync() ?? '';

  // Work
  stdout.write('Enter occupation (optional): ');
  final occupation = stdin.readLineSync() ?? '';

  stdout.write('Enter base (optional): ');
  final base = stdin.readLineSync() ?? '';

  // Connections
  stdout.write('Enter group affiliation (optional): ');
  final groupAffiliation = stdin.readLineSync() ?? '';

  stdout.write('Enter relatives (optional): ');
  final relatives = stdin.readLineSync() ?? '';

  // Image
  stdout.write('Enter image URL (optional): ');
  final imageUrl = stdin.readLineSync() ?? '';

  // Create HeroModel object
  final hero = HeroModel(
    name: name,
    powerstats: Powerstats(
      intelligence: intelligence,
      strength: strength,
      speed: speed,
      durability: durability,
      power: power,
      combat: combat,
    ),
    biography: Biography(
      fullName: fullName,
      alterEgos: alterEgos,
      aliases: [],
      placeOfBirth: '',
      firstAppearance: firstAppearance,
      publisher: publisher,
      alignment: alignment,
    ),
    appearance: Appearance(
      gender: gender,
      race: race,
      height: [],
      weight: [],
      eyeColor: eyeColor,
      hairColor: hairColor,
    ),
    work: Work(
      occupation: occupation,
      base: base,
    ),
    connections: Connections(
      groupAffiliation: groupAffiliation,
      relatives: relatives,
    ),
    image: HeroImage(
      url: imageUrl,
    ),
  );

  heroDataManager.addHero(hero);
  print('\nHero "${hero.name}" added successfully!\n');
}

// Keep the original calculate function for backwards compatibility
int calculate() {
  return 6 * 7;
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

// Search heroes by name (interactive)
void searchHeroesInteractive(HeroDataManager heroDataManager) {
  if (heroDataManager.heroes.isEmpty) {
    print('\nNo heroes to search.\n');
    return;
  }

  stdout.write('\nEnter name to search: ');
  final query = (stdin.readLineSync() ?? '').toLowerCase().trim();

  if (query.isEmpty) {
    print('Search query cannot be empty.\n');
    return;
  }

  final matches = heroDataManager.searchHeroesByName(query);

  if (matches.isEmpty) {
    print('\nNo heroes found matching "$query".\n');
  } else {
    print('\nFound ${matches.length} hero(es) matching "$query":');
    print('─────────────────────────────────────');
    for (var hero in matches) {
      _printHero(hero);
    }
    print('─────────────────────────────────────\n');
  }
}

// Show all heroes
void showHeroes(List<HeroModel> heroesToDisplay) {
  if (heroesToDisplay.isEmpty) {
    print('\nNo heroes in the database yet.\n');
    return;
  }

  print('\nALL HEROES (sorted by strength):');
  print('═══════════════════════════════════════');

  for (var hero in heroesToDisplay) {
    _printHero(hero);
  }

  print('═══════════════════════════════════════\n');
}

// Helper: Print a single hero
void _printHero(HeroModel hero) {
  print('  ID: ${hero.id} | Name: ${hero.name}');
  
  print('  POWERSTATS:');
  print('    Intelligence: ${hero.powerstats.intelligence}');
  print('    Strength: ${hero.powerstats.strength}');
  print('    Speed: ${hero.powerstats.speed}');
  print('    Durability: ${hero.powerstats.durability}');
  print('    Power: ${hero.powerstats.power}');
  print('    Combat: ${hero.powerstats.combat}');
  
  print('  BIOGRAPHY:');
  print('    Full Name: ${hero.biography.fullName}');
  print('    Alter Egos: ${hero.biography.alterEgos}');
  print('    Alignment: ${hero.biography.alignment}');
  print('    First Appearance: ${hero.biography.firstAppearance}');
  print('    Publisher: ${hero.biography.publisher}');
  
  print('  APPEARANCE:');
  print('    Gender: ${hero.appearance.gender}');
  print('    Race: ${hero.appearance.race}');
  print('    Eye Color: ${hero.appearance.eyeColor}');
  print('    Hair Color: ${hero.appearance.hairColor}');
  
  print('  WORK:');
  print('    Occupation: ${hero.work.occupation}');
  print('    Base: ${hero.work.base}');
  
  print('  CONNECTIONS:');
  print('    Group Affiliation: ${hero.connections.groupAffiliation}');
  print('    Relatives: ${hero.connections.relatives}');
  
  print('  IMAGE:');
  print('    URL: ${hero.image.url}');
  print('');
}