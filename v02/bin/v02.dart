import 'dart:io';

import 'package:v02/hero.dart';
import 'package:v02/v02.dart' as v02;

void main(List<String> arguments) {
  print('═══════════════════════════════════════');
  print('   🦸 Welcome to HeroDex 3000! 🦸');
  print('═══════════════════════════════════════\n');

  List<Hero> heroes = v02.loadHeroes();

  bool running = true;

  while (running) {
    v02.printMenu();
    stdout.write('Choose an option (1-4): ');
    final input = stdin.readLineSync();
    final choice = int.tryParse(input ?? '');

    switch (choice) {
      case 1:
        v02.addHero(heroes);
        v02.saveHeroesToJson(heroes);
        break;
      case 2:
        v02.showHeroes(heroes);
        break;
      case 3:
        v02.searchHeroes(heroes);
        break;
      case 4:
        print('\n👋 Exiting HeroDex 3000. Stay heroic!');
        running = false;
        break;
      default:
        print('\n❌ Invalid option. Please choose 1-4.\n');
    }
  }
}
