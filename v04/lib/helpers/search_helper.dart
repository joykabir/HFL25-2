import '../models/heromodel.dart';
import '../services/hero_data_manager.dart';
import 'hero_factory.dart';
import 'input_helper.dart';
import 'print_helper.dart';

class SearchHelper {
  static Future<void> searchExternalHeroes(
    HeroDataManager heroDataManager,
    bool verbose,
  ) async {
    final query = InputHelper.readNonEmpty('Enter name to search (external API): ');

    print('Searching external superhero API for "$query"...\n');

    try {
      PrintHelper.printDebug('Query: "$query"', verbose);
      PrintHelper.printDebug('Calling searchHeroesExternalByName()...', verbose);

      final matches = await heroDataManager.searchHeroesExternalByName(query);

      PrintHelper.printDebug('Retrieved ${matches.length} result(s) from API', verbose);

      if (matches.isEmpty) {
        PrintHelper.printError('No heroes found matching "$query" in external API.');
        return;
      }

      _displayExternalSearchResults(matches, heroDataManager, verbose);
      await _handleHeroSaving(matches, heroDataManager, verbose);

    } catch (e) {
      PrintHelper.printError('Error searching external API: $e');
      PrintHelper.printDebug('Exception: ${e.runtimeType}', verbose);
      PrintHelper.printDebug('Full error: $e', verbose);
    }
  }

  static Future<void> searchLocalHeroes(HeroDataManager heroDataManager) async {
    if (heroDataManager.heroes.isEmpty) {
      PrintHelper.printError('No heroes to search.');
      return;
    }

    final query = InputHelper.readNonEmpty('Enter name to search: ').toLowerCase();
    final matches = await heroDataManager.searchHeroesByName(query);

    if (matches.isEmpty) {
      PrintHelper.printError('No heroes found matching "$query".');
    } else {
      print('\nFound ${matches.length} hero(es) matching "$query":');
      print('─────────────────────────────────────');
      for (var hero in matches) {
        PrintHelper.printHero(hero);
      }
      print('─────────────────────────────────────\n');
    }
  }

  static void _displayExternalSearchResults(
    List<HeroModel> matches,
    HeroDataManager heroDataManager,
    bool verbose,
  ) {
    PrintHelper.printSuccess('Found ${matches.length} hero(es) from external API:');
    print('─────────────────────────────────────');

    for (int i = 0; i < matches.length; i++) {
      final hero = matches[i];
      final isAlreadySaved = heroDataManager.isExternalHeroAlreadySaved(hero.externalId ?? '');
      final statusIcon = isAlreadySaved ? '[SAVED]' : '[NEW]';
      final statusText = isAlreadySaved ? '(Already in collection)' : '(New)';

      print('${i + 1}. $statusIcon ${hero.name} $statusText');
      print('   External ID: ${hero.externalId}');
      print('   Publisher: ${hero.biography.publisher}');
      print('   Strength: ${hero.powerstats.strength}');

      if (isAlreadySaved) {
        print('   NOTE: This hero is already saved in your local collection');
      }

      if (verbose) {
        print('   [DEBUG] Full Name: ${hero.biography.fullName}');
        print('   [DEBUG] Alignment: ${hero.biography.alignment}');
      }

      print('');
    }
  }

  static Future<void> _handleHeroSaving(
    List<HeroModel> matches,
    HeroDataManager heroDataManager,
    bool verbose,
  ) async {
    final unsavedHeroes = matches
        .where((h) => !heroDataManager.isExternalHeroAlreadySaved(h.externalId ?? ''))
        .toList();

    if (unsavedHeroes.isEmpty) {
      PrintHelper.printInfo('All heroes from this search are already in your collection.');
      return;
    }

    print('─────────────────────────────────────');
    print('Available heroes to save: ${unsavedHeroes.length}');
    print('─────────────────────────────────────\n');

    while (true) {
      final choice = InputHelper.readInt(
        'Enter hero number to save (or 0 to return to menu): ',
        min: 0,
        max: matches.length,
      );

      if (choice == null) {
        PrintHelper.printError('Invalid selection. Please enter a number between 1-${matches.length} or 0 to exit.');
        continue;
      }

      if (choice == 0) {
        PrintHelper.printDebug('User chose to return to menu', verbose);
        print('\nReturning to main menu...\n');
        break;
      }

      final selectedHero = matches[choice - 1];
      PrintHelper.printDebug('Selected hero: ${selectedHero.name} (ID: ${selectedHero.externalId})', verbose);

      if (heroDataManager.isExternalHeroAlreadySaved(selectedHero.externalId ?? '')) {
        PrintHelper.printError('"${selectedHero.name}" is already in your collection!');
        continue;
      }

      final success = await _saveExternalHero(selectedHero, heroDataManager, verbose);
      
      if (success) {
        final remaining = matches
            .where((h) => !heroDataManager.isExternalHeroAlreadySaved(h.externalId ?? ''))
            .toList();

        if (remaining.isEmpty) {
          PrintHelper.printSuccess('All heroes from this search have been saved!');
          break;
        } else {
          PrintHelper.printInfo('Remaining heroes to save: ${remaining.length}');
        }
      }
    }

    print('─────────────────────────────────────\n');
  }

  static Future<bool> _saveExternalHero(
    HeroModel selectedHero,
    HeroDataManager heroDataManager,
    bool verbose,
  ) async {
    final heroToSave = HeroFactory.cloneWithNewId(selectedHero);

    PrintHelper.printDebug('Attempting to save hero with Internal ID: ${heroToSave.id}', verbose);

    final success = await heroDataManager.addHero(heroToSave);

    if (success) {
      PrintHelper.printSuccess('"${selectedHero.name}" saved to your local collection!');
      print('Internal ID: ${heroToSave.id}');
      print('External ID: ${heroToSave.externalId}');

      PrintHelper.printDebug('Hero saved successfully', verbose);
      PrintHelper.printDebug('Total heroes in collection: ${heroDataManager.heroes.length}', verbose);
    } else {
      PrintHelper.printError('Failed to save "${selectedHero.name}" to collection.');
      PrintHelper.printDebug('Save operation failed', verbose);
    }

    return success;
  }
}