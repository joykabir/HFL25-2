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
    print('  2. Show heroes only');
    print('  3. Show villains only');
    print('  4. Search local heroes by name');
    print('  5. Search external heroes by name (API Call)');
    print('  6. Delete local hero');
    print('  7. Exit');
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

  static void showHeroesOnly(List<HeroModel> allCharacters) {
    final heroes = allCharacters.where((character) => character.isHero).toList();
    
    if (heroes.isEmpty) {
      print('\nNo heroes found in the database.\n');
      return;
    }

    // Sort heroes by strength
    heroes.sort((a, b) {
      final aStrength = int.tryParse(a.powerstats.strength) ?? 0;
      final bStrength = int.tryParse(b.powerstats.strength) ?? 0;
      return bStrength.compareTo(aStrength);
    });

    print('\nHEROES ONLY (sorted by strength):');
    print('═══════════════════════════════════════');
    print('Found ${heroes.length} hero(s)');
    print('═══════════════════════════════════════');

    for (var hero in heroes) {
      print('>>> ${hero.characterType.toUpperCase()} <<<');
      printHero(hero);
    }

    print('═══════════════════════════════════════\n');
  }

  static void showVillainsOnly(List<HeroModel> allCharacters) {
    final villains = allCharacters.where((character) => character.isVillain).toList();
    
    if (villains.isEmpty) {
      print('\nNo villains found in the database.\n');
      return;
    }

    // Sort villains by strength
    villains.sort((a, b) {
      final aStrength = int.tryParse(a.powerstats.strength) ?? 0;
      final bStrength = int.tryParse(b.powerstats.strength) ?? 0;
      return bStrength.compareTo(aStrength);
    });

    print('\nVILLAINS ONLY (sorted by strength):');
    print('═══════════════════════════════════════');
    print('Found ${villains.length} villain(s)');
    print('═══════════════════════════════════════');

    for (var villain in villains) {
      print('>>> ${villain.characterType.toUpperCase()} <<<');
      printHero(villain);
    }

    print('═══════════════════════════════════════\n');
  }
}