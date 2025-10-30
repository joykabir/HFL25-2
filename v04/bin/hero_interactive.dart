import 'dart:io';

import 'package:v04/lib/models/appearance.dart';
import 'package:v03/models/biography.dart';
import 'package:v03/models/connections.dart';
import 'package:v03/models/heroimage.dart';
import 'package:v03/models/heromodel.dart';
import 'package:v03/models/powerstats.dart';
import 'package:v03/models/work.dart';
import 'package:v03/services/hero_data_manager.dart';

Future<void> addHeroInteractive(HeroDataManager heroDataManager) async {
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

  stdout.write('Enter aliases (comma-separated, optional): ');
  final aliasesInput = stdin.readLineSync() ?? '';
  final aliases = aliasesInput.isEmpty 
      ? <String>[] 
      : aliasesInput.split(',').map((alias) => alias.trim()).toList();

  stdout.write('Enter place of birth (optional): ');
  final placeOfBirth = stdin.readLineSync() ?? '';

  stdout.write('Enter first appearance (optional): ');
  final firstAppearance = stdin.readLineSync() ?? '';

  stdout.write('Enter publisher (optional): ');
  final publisher = stdin.readLineSync() ?? '';

  stdout.write('Enter alignment (good/evil, optional): ');
  final alignment = stdin.readLineSync() ?? '';

  //Starts Appearance
  stdout.write('Enter gender (optional): ');
  final gender = stdin.readLineSync() ?? '';

  stdout.write('Enter race (optional): ');
  final race = stdin.readLineSync() ?? '';

  stdout.write('Enter height (comma-separated, e.g., "6\'0", "183 cm", optional): ');
  final heightInput = stdin.readLineSync() ?? '';
  final height = heightInput.isEmpty 
      ? <String>[] 
      : heightInput.split(',').map((h) => h.trim()).toList();

  stdout.write('Enter weight (comma-separated, e.g., "180 lb", "82 kg", optional): ');
  final weightInput = stdin.readLineSync() ?? '';
  final weight = weightInput.isEmpty 
      ? <String>[] 
      : weightInput.split(',').map((w) => w.trim()).toList();

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
      aliases: aliases,
      placeOfBirth: placeOfBirth,
      firstAppearance: firstAppearance,
      publisher: publisher,
      alignment: alignment,
    ),
    appearance: Appearance(
      gender: gender,
      race: race,
      height: height,
      weight: weight,
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

  final success = await heroDataManager.addHero(hero);
  if (success) {
    print('\nHero "${hero.name}" added successfully!\n');
  } else {
    print('\nError adding hero "${hero.name}".\n');
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

Future<void> searchHeroesInteractive(HeroDataManager heroDataManager) async {
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

  final matches = await heroDataManager.searchHeroesByName(query);

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
  print('    Aliases: ${hero.biography.aliases.join(', ')}');
  print('    Place of Birth: ${hero.biography.placeOfBirth}');
  print('    First Appearance: ${hero.biography.firstAppearance}');
  print('    Publisher: ${hero.biography.publisher}');
  print('    Alignment: ${hero.biography.alignment}');
  
  print('  APPEARANCE:');
  print('    Gender: ${hero.appearance.gender}');
  print('    Race: ${hero.appearance.race}');
  print('    Height: ${hero.appearance.height.join(', ')}');
  print('    Weight: ${hero.appearance.weight.join(', ')}');
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