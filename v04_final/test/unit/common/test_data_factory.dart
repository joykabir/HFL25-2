import 'package:v03/models/appearance.dart';
import 'package:v03/models/biography.dart';
import 'package:v03/models/connections.dart';
import 'package:v03/models/heroimage.dart';
import 'package:v03/models/heromodel.dart';
import 'package:v03/models/powerstats.dart';
import 'package:v03/models/work.dart';

class TestDataFactory {
  // basic test hero with default values
  static HeroModel createTestHero({
    String name = 'Test Hero',
    String intelligence = '85',
    String strength = '75',
    String speed = '65',
    String durability = '55',
    String power = '45',
    String combat = '35',
  }) {
    return HeroModel(
      name: name,
      powerstats: createTestPowerstats(
        intelligence: intelligence,
        strength: strength,
        speed: speed,
        durability: durability,
        power: power,
        combat: combat,
      ),
      biography: createTestBiography(heroName: name),
      appearance: createTestAppearance(),
      work: createTestWork(),
      connections: createTestConnections(),
      image: createTestHeroImage(),
    );
  }


  static List<HeroModel> createMultipleTestHeroes(int count) {
    return List.generate(count, (index) => createTestHero(
      name: 'Test Hero ${index + 1}',
      strength: '${50 + (index * 10)}',
    ));
  }


  static HeroModel createHeroWithStrength(String name, String strength) {
    return createTestHero(name: name, strength: strength);
  }


  static HeroModel createEmptyHero() {
    return HeroModel(
      name: '',
      powerstats: createEmptyPowerstats(),
      biography: createEmptyBiography(),
      appearance: createEmptyAppearance(),
      work: createEmptyWork(),
      connections: createEmptyConnections(),
      image: createEmptyHeroImage(),
    );
  }


  static Powerstats createTestPowerstats({
    String intelligence = '85',
    String strength = '75',
    String speed = '65',
    String durability = '55',
    String power = '45',
    String combat = '35',
  }) {
    return Powerstats(
      intelligence: intelligence,
      strength: strength,
      speed: speed,
      durability: durability,
      power: power,
      combat: combat,
    );
  }

  static Powerstats createEmptyPowerstats() {
    return Powerstats(
      intelligence: '',
      strength: '',
      speed: '',
      durability: '',
      power: '',
      combat: '',
    );
  }

  static Biography createTestBiography({String heroName = 'Test Hero'}) {
    return Biography(
      fullName: '$heroName Full Name',
      alterEgos: 'No alter egos found',
      aliases: ['${heroName}y', 'The $heroName'],
      placeOfBirth: 'Test City',
      firstAppearance: 'Test Comics #1',
      publisher: 'Test Publisher',
      alignment: 'good',
    );
  }

  static Biography createEmptyBiography() {
    return Biography(
      fullName: '',
      alterEgos: '',
      aliases: [],
      placeOfBirth: '',
      firstAppearance: '',
      publisher: '',
      alignment: '',
    );
  }

  static Appearance createTestAppearance() {
    return Appearance(
      gender: 'Male',
      race: 'Human',
      height: ['6\'0"', '183 cm'],
      weight: ['175 lb', '79 kg'],
      eyeColor: 'Blue',
      hairColor: 'Brown',
    );
  }

  static Appearance createEmptyAppearance() {
    return Appearance(
      gender: '',
      race: '',
      height: [],
      weight: [],
      eyeColor: '',
      hairColor: '',
    );
  }

  static Work createTestWork() {
    return Work(
      occupation: 'Software Developer, Hero',
      base: 'Test City HQ',
    );
  }

  static Work createEmptyWork() {
    return Work(
      occupation: '',
      base: '',
    );
  }

  static Connections createTestConnections() {
    return Connections(
      groupAffiliation: 'Test Team, Justice League',
      relatives: 'Test Family Members',
    );
  }

  static Connections createEmptyConnections() {
    return Connections(
      groupAffiliation: '',
      relatives: '',
    );
  }

  static HeroImage createTestHeroImage() {
    return HeroImage(
      url: 'https://test.example.com/hero-image.jpg',
    );
  }

  static HeroImage createEmptyHeroImage() {
    return HeroImage(
      url: '',
    );
  }

  static HeroModel createMarvelHero(String name) {
    final hero = createTestHero(name: name);
    return HeroModel(
      name: hero.name,
      powerstats: hero.powerstats,
      biography: Biography(
        fullName: hero.biography.fullName,
        alterEgos: hero.biography.alterEgos,
        aliases: hero.biography.aliases,
        placeOfBirth: hero.biography.placeOfBirth,
        firstAppearance: hero.biography.firstAppearance,
        publisher: 'Marvel Comics',
        alignment: hero.biography.alignment,
      ),
      appearance: hero.appearance,
      work: hero.work,
      connections: hero.connections,
      image: hero.image,
    );
  }

  static HeroModel createDCHero(String name) {
    final hero = createTestHero(name: name);
    return HeroModel(
      name: hero.name,
      powerstats: hero.powerstats,
      biography: Biography(
        fullName: hero.biography.fullName,
        alterEgos: hero.biography.alterEgos,
        aliases: hero.biography.aliases,
        placeOfBirth: hero.biography.placeOfBirth,
        firstAppearance: hero.biography.firstAppearance,
        publisher: 'DC Comics',
        alignment: hero.biography.alignment,
      ),
      appearance: hero.appearance,
      work: hero.work,
      connections: hero.connections,
      image: hero.image,
    );
  }
}