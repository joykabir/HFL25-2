import 'dart:io';

import 'package:v04/models/appearance.dart';
import 'package:v04/models/biography.dart';
import 'package:v04/models/connections.dart';
import 'package:v04/models/heroimage.dart';
import 'package:v04/models/heromodel.dart';
import 'package:v04/models/powerstats.dart';
import 'package:v04/models/work.dart';
import 'package:v04/services/hero_data_manager.dart';

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
  print('  3. Search heroes by name (local)');
  print('  4. Search external heroes by name (external API)');
  print('  5. Exit');
  print('─────────────────────────────────────');
}

Future<void> searchExternalHeroesInteractive(
  HeroDataManager heroDataManager,
  bool verbose,
) async {
  stdout.write('\nEnter name to search (external API): ');
  final query = (stdin.readLineSync() ?? '').trim();

  if (query.isEmpty) {
    print('Search query cannot be empty.\n');
    return;
  }

  print('🔍 Searching external superhero API for "$query"...\n');

  try {
    if (verbose) {
      print('[DEBUG] Query: "$query"');
      print('[DEBUG] Calling searchHeroesExternalByName()...');
    }

    final matches = await heroDataManager.searchHeroesExternalByName(query);

    if (verbose) {
      print('[DEBUG] Retrieved ${matches.length} result(s) from API\n');
    }

    if (matches.isEmpty) {
      print('❌ No heroes found matching "$query" in external API.\n');
      return;
    }

    // Display all results
    print('✅ Found ${matches.length} hero(es) from external API:');
    print('─────────────────────────────────────');
    
    for (int i = 0; i < matches.length; i++) {
      final hero = matches[i];
      final isAlreadySaved = heroDataManager.isExternalHeroAlreadySaved(hero.externalId ?? '');
      final statusIcon = isAlreadySaved ? '💾' : '🆕';
      final statusText = isAlreadySaved ? '(Already in collection)' : '(New)';
      
      print('${i + 1}. $statusIcon ${hero.name} $statusText');
      print('   External ID: ${hero.externalId}');
      print('   Publisher: ${hero.biography.publisher}');
      print('   Strength: ${hero.powerstats.strength}');
      
      if (isAlreadySaved) {
        print('   ⚠️  This hero is already saved in your local collection');
      }
      
      if (verbose) {
        print('   [DEBUG] Full Name: ${hero.biography.fullName}');
        print('   [DEBUG] Alignment: ${hero.biography.alignment}');
      }
      
      print('');
    }

    // Filter unsaved heroes
    final unsavedHeroes = matches
        .where((h) => !heroDataManager.isExternalHeroAlreadySaved(h.externalId ?? ''))
        .toList();

    if (unsavedHeroes.isEmpty) {
      print('ℹ️  All heroes from this search are already in your collection.\n');
      return;
    }

    print('─────────────────────────────────────');
    print('Available heroes to save: ${unsavedHeroes.length}');
    print('─────────────────────────────────────\n');

    // Loop: Ask user to save heroes until they choose 0 or all are saved
    bool savingLoop = true;
    while (savingLoop) {
      stdout.write('Enter hero number to save (or 0 to return to menu): ');
      final choiceInput = stdin.readLineSync() ?? '';
      final choice = int.tryParse(choiceInput);

      if (verbose) {
        print('[DEBUG] User input: "$choiceInput" → Parsed as: $choice');
      }

      // Check if user wants to exit
      if (choice == 0) {
        if (verbose) {
          print('[DEBUG] User chose to return to menu');
        }
        print('\n↩️  Returning to main menu...\n');
        savingLoop = false;
        break;
      }

      // Validate selection
      if (choice == null || choice < 0 || choice > matches.length) {
        print('❌ Invalid selection. Please enter a number between 1-${matches.length} or 0 to exit.\n');
        continue;
      }

      // Get selected hero
      final selectedHero = matches[choice - 1];

      if (verbose) {
        print('[DEBUG] Selected hero: ${selectedHero.name} (ID: ${selectedHero.externalId})');
      }

      // Check if already saved (double-check)
      if (heroDataManager.isExternalHeroAlreadySaved(selectedHero.externalId ?? '')) {
        print('❌ "${selectedHero.name}" is already in your collection!');
        
        // Show remaining unsaved heroes
        final remainingUnsaved = matches
            .where((h) => !heroDataManager.isExternalHeroAlreadySaved(h.externalId ?? ''))
            .toList();
        
        if (remainingUnsaved.isEmpty) {
          print('ℹ️  No more heroes to save from this search.\n');
          savingLoop = false;
          break;
        }
        
        print('ℹ️  Remaining heroes to save: ${remainingUnsaved.length}\n');
        continue;
      }

      // Create hero to save
      final heroToSave = HeroModel(
        externalId: selectedHero.externalId,
        name: selectedHero.name,
        powerstats: selectedHero.powerstats,
        biography: selectedHero.biography,
        appearance: selectedHero.appearance,
        work: selectedHero.work,
        connections: selectedHero.connections,
        image: selectedHero.image,
      );

      if (verbose) {
        print('[DEBUG] Attempting to save hero with Internal ID: ${heroToSave.id}');
      }

      // Save hero
      final success = await heroDataManager.addHero(heroToSave);

      if (success) {
        print('✅ "${selectedHero.name}" saved to your local collection!');
        print('   📋 Internal ID: ${heroToSave.id}');
        print('   🌐 External ID: ${heroToSave.externalId}');
        
        if (verbose) {
          print('[DEBUG] Hero saved successfully');
          print('[DEBUG] Total heroes in collection: ${heroDataManager.heroes.length}');
        }

        // Show remaining unsaved heroes
        final remainingUnsaved = matches
            .where((h) => !heroDataManager.isExternalHeroAlreadySaved(h.externalId ?? ''))
            .toList();

        if (remainingUnsaved.isEmpty) {
          print('\n🎉 All heroes from this search have been saved!\n');
          savingLoop = false;
          break;
        } else {
          print('ℹ️  Remaining heroes to save: ${remainingUnsaved.length}\n');
          continue;
        }
      } else {
        print('❌ Failed to save "${selectedHero.name}" to collection.\n');

        if (verbose) {
          print('[DEBUG] Save operation failed');
        }
      }
    }

    print('─────────────────────────────────────\n');

  } catch (e) {
    print('❌ Error searching external API: $e\n');

    if (verbose) {
      print('[DEBUG] Exception: ${e.runtimeType}');
      print('[DEBUG] Full error: $e');
    }
  }
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
  print('  Internal ID: ${hero.id}');
  if (hero.externalId != null && hero.externalId!.isNotEmpty) {
    print('  External ID: ${hero.externalId} 🌐');
  }
  print('  Name: ${hero.name}');
  
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