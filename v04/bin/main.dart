import 'dart:io';

import 'package:args/args.dart';
import 'package:v04/helpers/delete_helper.dart';
import 'package:v04/helpers/hero_factory.dart';
import 'package:v04/helpers/print_helper.dart';
import 'package:v04/helpers/search_helper.dart';
import 'package:v04/services/hero_data_manager.dart';

Future<void> main(List<String> arguments) async {
  final argParser = buildParser();

  try {
    final results = argParser.parse(arguments);
    final bool verbose = results['verbose'] as bool;

    if (results['help'] as bool) {
      printUsage(argParser);
      return;
    }

    if (results['version'] as bool) {
      print('HeroDex 3000 version: $version');
      return;
    }

    // Initialize the singleton manager
    final heroDataManager = HeroDataManager();
    await heroDataManager.loadHeroes();

    if (verbose) {
      print('[INFO] Loaded ${heroDataManager.heroes.length} heroes from local heroes.json file.\n');
    }

    print('═══════════════════════════════════════');
    print('   Welcome to HeroDex 3000!');
    print('═══════════════════════════════════════\n');

    bool running = true;

    while (running) {
      PrintHelper.printMenu();
      stdout.write('Choose an option (1-7): ');
      final input = stdin.readLineSync();
      final choice = int.tryParse(input ?? '');

      switch (choice) {
        case 1:
          await _addHeroInteractive(heroDataManager, verbose);
          break;
          
        case 2:
          PrintHelper.showHeroesOnly(heroDataManager.heroes);
          break;
          
        case 3:
          PrintHelper.showVillainsOnly(heroDataManager.heroes);
          break;
          
        case 4:
          await SearchHelper.searchLocalHeroes(heroDataManager);
          break;
        
        case 5:
          await SearchHelper.searchExternalHeroes(heroDataManager, verbose);
          break;
          
        case 6:
          await DeleteHelper.deleteHeroInteractive(heroDataManager, verbose);
          break;
          
        case 7:
          print('\nExiting the program!\n');
          if (verbose) {
            print('[INFO] Gracefully closed the program.');
          }
          running = false;
          break;
          
        default:
          print('\nInvalid option. Please choose 1-7.\n');
      }
    }
  } on FormatException catch (e) {
    print('Error: ${e.message}');
    print('');
    printUsage(argParser);
    exit(1);
  } catch (e) {
    print('Unexpected error: $e');
    exit(1);
  }
}

const String version = '0.0.5';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Display this help message.',
    )
    ..addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Display the version.',
    )
    ..addFlag(
      'verbose',
      negatable: false,
      help: 'Show verbose output including debug information.',
    );
}

void printUsage(ArgParser argParser) {
  print('''
HeroDex 3000 - Superhero Tracking Application

Usage:
  dart run bin/main.dart [options]

${argParser.usage}

Examples:
  dart run bin/main.dart --help
  dart run bin/main.dart --version
  dart run bin/main.dart --verbose

Features:
  • Add heroes manually with detailed information
  • Search and import heroes from external superhero API
  • View all heroes sorted by strength
  • Search local hero collection by name
  • Delete heroes from collection
  • Automatic duplicate prevention for external heroes

Menu Options:
  1. Add Hero Locally - Create a new hero manually
  2. Show Heroes Only - Display only heroes sorted by strength
  3. Show Villains Only - Display only villains sorted by strength
  4. Search Local Heroes - Find heroes by name in your collection
  5. Search External Heroes - Find and import heroes from API
  6. Delete Local Hero - Remove a hero from your collection
  7. Exit - Close the application

Data Storage:
  • Heroes are stored locally in heroes.json
  • External API heroes preserve their original IDs
  • Each hero gets a unique internal UUID
''');
}

Future<void> _addHeroInteractive(HeroDataManager heroDataManager, bool verbose) async {
  try {
    final hero = await HeroFactory.createHeroInteractively();
    final success = await heroDataManager.addHero(hero);
    
    if (success) {
      PrintHelper.printSuccess('Hero "${hero.name}" added successfully!');
      
      if (verbose) {
        print('[INFO] Hero saved successfully. Total heroes: ${heroDataManager.heroes.length}');
        print('[DEBUG] Hero ID: ${hero.id}');
        print('[DEBUG] Hero strength: ${hero.powerstats.strength}');
      }
    } else {
      PrintHelper.printError('Error adding hero "${hero.name}".');
      
      if (verbose) {
        print('[ERROR] Failed to save hero to collection.');
      }
    }
  } catch (e) {
    PrintHelper.printError('Failed to create hero: $e');
    
    if (verbose) {
      print('[ERROR] Exception during hero creation: $e');
    }
  }
}