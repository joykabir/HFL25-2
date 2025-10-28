import 'package:v03/models/appearance.dart';
import 'package:v03/models/biography.dart';
import 'package:v03/models/connections.dart';
import 'package:v03/models/heroimage.dart';
import 'package:v03/models/heromodel.dart';
import 'package:v03/models/powerstats.dart';
import 'package:v03/models/work.dart';
import 'package:v03/services/hero_data_managing.dart';

class MockHeroDataManager implements HeroDataManaging {
  static final MockHeroDataManager _instance = MockHeroDataManager._internal();
  
  late List<HeroModel> _heroes;

  factory MockHeroDataManager() {
    return _instance;
  }

  MockHeroDataManager._internal() {
    _heroes = _generateMockHeroes();
  }

  @override
  List<HeroModel> get heroes => _heroes;

  @override
  Future<bool> addHero(HeroModel hero) async {
    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 500));
    
    try {
      _heroes.add(hero);
      return true;
    } catch (e) {
      print('Mock API Error adding hero: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteHero(String id) async {
    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 300));
    
    try {
      final initialLength = _heroes.length;
      _heroes.removeWhere((hero) => hero.id == id);
      return _heroes.length < initialLength;
    } catch (e) {
      print('Mock API Error deleting hero: $e');
      return false;
    }
  }

  @override
  Future<void> loadHeroes() async {
    // Simulate API loading delay
    await Future.delayed(Duration(milliseconds: 1000));
    
    print('Mock API: Loading heroes from fake superhero API...');
    _heroes = _generateMockHeroes();
  }

  @override
  Future<bool> saveHeroes() async {
    // Simulate API save delay
    await Future.delayed(Duration(milliseconds: 800));
    
    print('Mock API: Heroes saved to fake cloud storage');
    return true;
  }

  @override
  Future<List<HeroModel>> searchHeroesByName(String query) async {
    // Simulate API search delay
    await Future.delayed(Duration(milliseconds: 400));
    
    if (_heroes.isEmpty) {
      return [];
    }

    final lowerQuery = query.toLowerCase().trim();
    return _heroes
        .where((hero) => hero.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  List<HeroModel> getHeroesSortedByStrength() {
    final sorted = List<HeroModel>.from(_heroes);
    sorted.sort((a, b) {
      final aStrength = int.tryParse(a.powerstats.strength) ?? 0;
      final bStrength = int.tryParse(b.powerstats.strength) ?? 0;
      return bStrength.compareTo(aStrength);
    });
    return sorted;
  }


  // Three mock heroes for testing
  List<HeroModel> _generateMockHeroes() {
    return [
      HeroModel(
        name: 'Spider-Man',
        powerstats: Powerstats(
          intelligence: '90',
          strength: '55',
          speed: '67',
          durability: '75',
          power: '74',
          combat: '85',
        ),
        biography: Biography(
          fullName: 'Peter Benjamin Parker',
          alterEgos: 'No alter egos found',
          aliases: ['Spidey', 'Web-Slinger', 'Wall-Crawler'],
          placeOfBirth: 'New York City',
          firstAppearance: 'Amazing Fantasy #15',
          publisher: 'Marvel Comics',
          alignment: 'good',
        ),
        appearance: Appearance(
          gender: 'Male',
          race: 'Human',
          height: ['5\'10"', '178 cm'],
          weight: ['167 lb', '76 kg'],
          eyeColor: 'Hazel',
          hairColor: 'Brown',
        ),
        work: Work(
          occupation: 'Photographer, Teacher, Scientist',
          base: 'New York City',
        ),
        connections: Connections(
          groupAffiliation: 'Avengers, Fantastic Four',
          relatives: 'May Parker (aunt), Ben Parker (uncle)',
        ),
        image: HeroImage(
          url: 'https://www.superherodb.com/pictures2/portraits/10/100/133.jpg',
        ),
      ),
      HeroModel(
        name: 'Batman',
        powerstats: Powerstats(
          intelligence: '100',
          strength: '26',
          speed: '27',
          durability: '50',
          power: '47',
          combat: '100',
        ),
        biography: Biography(
          fullName: 'Bruce Wayne',
          alterEgos: 'No alter egos found',
          aliases: ['Dark Knight', 'World\'s Greatest Detective', 'Caped Crusader'],
          placeOfBirth: 'Gotham City',
          firstAppearance: 'Detective Comics #27',
          publisher: 'DC Comics',
          alignment: 'good',
        ),
        appearance: Appearance(
          gender: 'Male',
          race: 'Human',
          height: ['6\'2"', '188 cm'],
          weight: ['210 lb', '95 kg'],
          eyeColor: 'Blue',
          hairColor: 'Black',
        ),
        work: Work(
          occupation: 'Businessman, Vigilante',
          base: 'Gotham City, Wayne Manor',
        ),
        connections: Connections(
          groupAffiliation: 'Justice League, Batman Family',
          relatives: 'Thomas Wayne (father), Martha Wayne (mother)',
        ),
        image: HeroImage(
          url: 'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
        ),
      ),
      HeroModel(
        name: 'Wonder Woman',
        powerstats: Powerstats(
          intelligence: '88',
          strength: '100',
          speed: '79',
          durability: '100',
          power: '100',
          combat: '100',
        ),
        biography: Biography(
          fullName: 'Diana Prince',
          alterEgos: 'No alter egos found',
          aliases: ['Princess Diana', 'Diana of Themyscira'],
          placeOfBirth: 'Themyscira',
          firstAppearance: 'All Star Comics #8',
          publisher: 'DC Comics',
          alignment: 'good',
        ),
        appearance: Appearance(
          gender: 'Female',
          race: 'Amazon',
          height: ['6\'0"', '183 cm'],
          weight: ['165 lb', '75 kg'],
          eyeColor: 'Blue',
          hairColor: 'Black',
        ),
        work: Work(
          occupation: 'Princess, Warrior, Ambassador',
          base: 'Themyscira, Gateway City',
        ),
        connections: Connections(
          groupAffiliation: 'Justice League, Amazons',
          relatives: 'Hippolyta (mother), Zeus (father)',
        ),
        image: HeroImage(
          url: 'https://www.superherodb.com/pictures2/portraits/10/100/807.jpg',
        ),
      ),
      HeroModel(
        name: 'Black Widow',
        powerstats: Powerstats(
          intelligence: '75',
          strength: '13',
          speed: '33',
          durability: '30',
          power: '36',
          combat: '100',
        ),
        biography: Biography(
          fullName: 'Natasha Alianovna Romanova',
          alterEgos: 'No alter egos found',
          aliases: ['Natasha Romanoff', 'Natalie Rushman', 'Black Widow'],
          placeOfBirth: 'Stalingrad, Russia',
          firstAppearance: 'Tales of Suspense #52',
          publisher: 'Marvel Comics',
          alignment: 'good',
        ),
        appearance: Appearance(
          gender: 'Female',
          race: 'Human',
          height: ['5\'7"', '170 cm'],
          weight: ['131 lb', '59 kg'],
          eyeColor: 'Green',
          hairColor: 'Auburn',
        ),
        work: Work(
          occupation: 'Spy, Adventurer, Government Agent',
          base: 'Avengers Mansion',
        ),
        connections: Connections(
          groupAffiliation: 'Avengers, S.H.I.E.L.D., Thunderbolts',
          relatives: 'Alexi Shostakov (Red Guardian, estranged husband)',
        ),
        image: HeroImage(
          url: 'https://www.superherodb.com/pictures2/portraits/10/100/248.jpg',
        ),
      ),
    ];
  }
}