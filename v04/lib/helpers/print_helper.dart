import '../models/heromodel.dart';

class PrintHelper {
  static void printDebug(String message, bool verbose) {
    if (verbose) {
      print('[DEBUG] $message');
    }
  }

  static void printError(String message) {
    print('\n[ERROR] $message\n');
  }

  static void printHero(HeroModel hero) {
    print('Internal ID: ${hero.id}');
    if (hero.externalId != null && hero.externalId!.isNotEmpty) {
      print('External ID: ${hero.externalId} (EXTERNAL)');
    }
    print('Name: ${hero.name}');

    print('POWERSTATS:');
    print('  Intelligence: ${hero.powerstats.intelligence}');
    print('  Strength: ${hero.powerstats.strength}');
    print('  Speed: ${hero.powerstats.speed}');
    print('  Durability: ${hero.powerstats.durability}');
    print('  Power: ${hero.powerstats.power}');
    print('  Combat: ${hero.powerstats.combat}');

    print('BIOGRAPHY:');
    print('  Full Name: ${hero.biography.fullName}');
    print('  Alter Egos: ${hero.biography.alterEgos}');
    print('  Aliases: ${hero.biography.aliases.join(', ')}');
    print('  Place of Birth: ${hero.biography.placeOfBirth}');
    print('  First Appearance: ${hero.biography.firstAppearance}');
    print('  Publisher: ${hero.biography.publisher}');
    print('  Alignment: ${hero.biography.alignment}');

    print('APPEARANCE:');
    print('  Gender: ${hero.appearance.gender}');
    print('  Race: ${hero.appearance.race}');
    print('  Height: ${hero.appearance.height.join(', ')}');
    print('  Weight: ${hero.appearance.weight.join(', ')}');
    print('  Eye Color: ${hero.appearance.eyeColor}');
    print('  Hair Color: ${hero.appearance.hairColor}');

    print('WORK:');
    print('  Occupation: ${hero.work.occupation}');
    print('  Base: ${hero.work.base}');

    print('CONNECTIONS:');
    print('  Group Affiliation: ${hero.connections.groupAffiliation}');
    print('  Relatives: ${hero.connections.relatives}');

    print('IMAGE:');
    print('  URL: ${hero.image.url}');
    print('');
  }

  static void printInfo(String message) {
    print('\n[INFO] $message\n');
  }

  static void printMenu() {
    print('─────────────────────────────────────');
    print('  MENU:');
    print('  1. Add hero locally');
    print('  2. Show local heroes');
    print('  3. Search local heroes by name');
    print('  4. Search external heroes by name (API Call)');
    print('  5. Delete local hero');
    print('  6. Exit');
    print('─────────────────────────────────────');
  }

  static void printSuccess(String message) {
    print('\n[SUCCESS] $message\n');
  }

  static void showHeroes(List<HeroModel> heroesToDisplay) {
    if (heroesToDisplay.isEmpty) {
      print('\nNo heroes in the database yet.\n');
      return;
    }

    print('\nALL HEROES (sorted by strength):');
    print('═══════════════════════════════════════');

    for (var hero in heroesToDisplay) {
      printHero(hero);
    }

    print('═══════════════════════════════════════\n');
  }
}