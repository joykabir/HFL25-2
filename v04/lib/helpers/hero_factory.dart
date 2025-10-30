import '../models/appearance.dart';
import '../models/biography.dart';
import '../models/connections.dart';
import '../models/heroimage.dart';
import '../models/heromodel.dart';
import '../models/powerstats.dart';
import '../models/work.dart';
import 'input_helper.dart';

class HeroFactory {
  static HeroModel cloneWithNewId(HeroModel source) {
    return HeroModel(
      externalId: source.externalId,
      name: source.name,
      powerstats: source.powerstats,
      biography: source.biography,
      appearance: source.appearance,
      work: source.work,
      connections: source.connections,
      image: source.image,
    );
  }

  static Future<HeroModel> createHeroInteractively() async {
    print('\nAdding a new hero...');

    final name = InputHelper.readNonEmpty('Enter hero name: ');

    // Powerstats
    final intelligence = InputHelper.readString('Enter intelligence (0-100): ', defaultValue: '0');
    final strength = InputHelper.readString('Enter strength (0-100): ', defaultValue: '0');
    final speed = InputHelper.readString('Enter speed (0-100): ', defaultValue: '0');
    final durability = InputHelper.readString('Enter durability (0-100): ', defaultValue: '0');
    final power = InputHelper.readString('Enter power (0-100): ', defaultValue: '0');
    final combat = InputHelper.readString('Enter combat (0-100): ', defaultValue: '0');

    // Biography
    final fullName = InputHelper.readString('Enter full name (optional): ');
    final alterEgos = InputHelper.readString('Enter alter egos (optional): ');
    final aliases = InputHelper.readStringList('Enter aliases (comma-separated, optional): ');
    final placeOfBirth = InputHelper.readString('Enter place of birth (optional): ');
    final firstAppearance = InputHelper.readString('Enter first appearance (optional): ');
    final publisher = InputHelper.readString('Enter publisher (optional): ');
    final alignment = InputHelper.readString('Enter alignment (good/evil, optional): ');

    // Appearance
    final gender = InputHelper.readString('Enter gender (optional): ');
    final race = InputHelper.readString('Enter race (optional): ');
    final height = InputHelper.readStringList('Enter height (comma-separated, e.g., "6\'0", "183 cm", optional): ');
    final weight = InputHelper.readStringList('Enter weight (comma-separated, e.g., "180 lb", "82 kg", optional): ');
    final eyeColor = InputHelper.readString('Enter eye color (optional): ');
    final hairColor = InputHelper.readString('Enter hair color (optional): ');

    // Work
    final occupation = InputHelper.readString('Enter occupation (optional): ');
    final base = InputHelper.readString('Enter base (optional): ');

    // Connections
    final groupAffiliation = InputHelper.readString('Enter group affiliation (optional): ');
    final relatives = InputHelper.readString('Enter relatives (optional): ');

    // Image
    final imageUrl = InputHelper.readString('Enter image URL (optional): ');

    return HeroModel(
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
  }
}