import '../models/heromodel.dart';
import '../services/hero_data_manager.dart';
import 'input_helper.dart';
import 'print_helper.dart';

class DeleteHelper {
  static Future<void> deleteHeroInteractive(
    HeroDataManager heroDataManager,
    bool verbose,
  ) async {
    if (heroDataManager.heroes.isEmpty) {
      PrintHelper.printError('No heroes in your collection to delete.');
      return;
    }

    print('\n═══════════════════════════════════════');
    print('  DELETE HERO');
    print('═══════════════════════════════════════');

    _displayHeroesForDeletion(heroDataManager.heroes);

    final choice = InputHelper.readInt(
      'Enter hero number to delete (or 0 to cancel): ',
      min: 0,
      max: heroDataManager.heroes.length,
    );

    PrintHelper.printDebug('User input parsed as: $choice', verbose);

    if (choice == null) {
      PrintHelper.printError('Invalid selection. Please enter a number between 1-${heroDataManager.heroes.length} or 0 to cancel.');
      return;
    }

    if (choice == 0) {
      PrintHelper.printDebug('User cancelled delete operation', verbose);
      print('\nDelete operation cancelled.\n');
      return;
    }

    final selectedHero = heroDataManager.heroes[choice - 1];
    PrintHelper.printDebug('Selected hero for deletion: ${selectedHero.name} (ID: ${selectedHero.id})', verbose);

    if (!_confirmDeletion(selectedHero, verbose)) {
      print('\nDelete cancelled.\n');
      return;
    }

    await _performDeletion(selectedHero, heroDataManager, verbose);
  }

  static bool _confirmDeletion(HeroModel selectedHero, bool verbose) {
    print('\nWARNING: You are about to delete "${selectedHero.name}"');
    final confirmed = InputHelper.readConfirmation('Are you sure? (yes/no): ');
    
    PrintHelper.printDebug('Confirmation input result: $confirmed', verbose);
    return confirmed;
  }

  static void _displayHeroesForDeletion(List<HeroModel> heroes) {
    for (int i = 0; i < heroes.length; i++) {
      final hero = heroes[i];
      final externalMarker = hero.externalId != null && hero.externalId!.isNotEmpty ? ' (EXTERNAL)' : '';
      print('${i + 1}. ${hero.name}$externalMarker');
      print('   ID: ${hero.id}');
      print('   Strength: ${hero.powerstats.strength}');
      print('');
    }
    print('─────────────────────────────────────');
  }

  static Future<void> _performDeletion(
    HeroModel selectedHero,
    HeroDataManager heroDataManager,
    bool verbose,
  ) async {
    final success = await heroDataManager.deleteHero(selectedHero.id);

    if (success) {
      PrintHelper.printSuccess('Hero "${selectedHero.name}" has been deleted successfully!');
      print('Remaining heroes: ${heroDataManager.heroes.length}\n');

      PrintHelper.printDebug('Hero deleted successfully', verbose);
      PrintHelper.printDebug('Total heroes after deletion: ${heroDataManager.heroes.length}', verbose);
    } else {
      PrintHelper.printError('Failed to delete "${selectedHero.name}".');
      PrintHelper.printDebug('Delete operation failed', verbose);
    }
  }
}