import 'dart:io';

import 'package:v03/models/hero.dart';
import 'package:v03/v03.dart' as v03;

void main(List<String> arguments) {
  print('═══════════════════════════════════════');
  print('   Welcome to HeroDex 3000!');
  print('═══════════════════════════════════════\n');

  List<Hero> heroes = v03.loadHeroes();

  bool running = true;

  while (running) {
    v03.printMenu();
    stdout.write('Choose an option (1-4): ');
    final input = stdin.readLineSync();
    final choice = int.tryParse(input ?? '');

    switch (choice) {
      case 1:
        v03.addHero(heroes);
        v03.saveHeroesToJson(heroes);
        break;
      case 2:
        v03.showHeroes(heroes);
        break;
      case 3:
        v03.searchHeroes(heroes);
        break;
      case 4:
        print('\nExiting HeroDex 3000. Stay heroic!');
        running = false;
        break;
      default:
        print('\nInvalid option. Please choose 1-4.\n');
    }
  }
}