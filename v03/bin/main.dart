import 'dart:io';

import 'package:args/args.dart';
import 'package:v03/services/hero_data_manager.dart';
import 'package:v03/v03.dart' as v03;


void main(List<String> arguments) {
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
    heroDataManager.loadHeroes();

    if (verbose) {
      print('[INFO] Loaded ${heroDataManager.heroes.length} heroes from database.\n');
    }


    print('═══════════════════════════════════════');
    print('   Welcome to HeroDex 3000!');
    print('═══════════════════════════════════════\n');

    bool running = true;

    while (running) {
      v03.printMenu();
      stdout.write('Choose an option (1-4): ');
      final input = stdin.readLineSync();
      final choice = int.tryParse(input ?? '');

      switch (choice) {
        case 1:
          v03.addHeroInteractive(heroDataManager);
          heroDataManager.saveHeroes();
          if (verbose) {
            print('[INFO] Hero saved. Total heroes: ${heroDataManager.heroes.length}');
          }
          break;
        case 2:
          v03.showHeroes(heroDataManager.getHeroesSortedByStrength());
          break;
        case 3:
          v03.searchHeroesInteractive(heroDataManager);
          break;
        case 4:
          print('\nExiting the program!\n');
          if (verbose) {
            print('[INFO] Program terminated gracefully.');
          }
          running = false;
          break;
        default:
          print('\nInvalid option. Please choose 1-4.\n');
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

const String version = '0.0.3';



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
      help: 'Show verbose output.',
    );
}


void printUsage(ArgParser argParser) {
  print('''
HeroDex 3000 - Superhero Tracking 

Usage:
  dart run bin/main.dart [options]

${argParser.usage}

Examples:
  dart run bin/main.dart --help
  dart run bin/main.dart --version
  dart run bin/main.dart --verbose

When running the program:
  1. Add Hero - Create a new hero with details
  2. Show Heroes - Display all heroes sorted by strength
  3. Search Heroes - Find heroes by unique name
  4. Exit - Close the program
''');
}