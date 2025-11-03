/// Application-wide constants
class AppConstants {
  // API Configuration
  static const String defaultApiUrl = 'https://superheroapi.com/api';
  static const String envFileName = '.env';
  static const String envApiKeyVariable = 'SUPERHERO_API_KEY';
  static const String envApiUrlVariable = 'SUPERHERO_API_URL';

  // Local Storage
  static const String heroesFileName = 'heroes.json';
  static const String heroesFileBackup = 'heroes_backup.json';

  // HTTP Configuration
  static const Duration httpTimeout = Duration(seconds: 30);
  static const Map<String, String> defaultHttpHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // API Endpoints
  static const String searchEndpoint = 'search';
  static const String detailsEndpoint = '';

  // UI Constants
  static const String appName = 'HeroDex 3000';
  static const String appVersion = '0.0.3';

  // Hero Classifications
  static const String heroType = 'Superhero';
  static const String villainType = 'Supervillain';

  static const List<String> heroAlignments = [
    'good',
    'lawful good',
    'neutral good',
    'honorable',
    'righteous',
    'just',
    'orderly',
    'heroic',
    'protector',
    'guardian',
    'defender',
    'peacekeeper',
    'virtuous',
    'god',
  ];

  static const List<String> villainAlignments = [
    'evil',
    'chaotic evil',
    'neutral evil',
    'lawful evil',
    'bad',
    'corrupt',
    'cruel',
    'malicious',
    'malevolent',
    'wicked',
    'tyrannical',
    'dark',
    'ruthless',
    'vengeful',
  ];

  // Menu Options
  static const List<String> menuOptions = [
    'Add hero',
    'Show heroes only',
    'Show villains only', 
    'Search heroes by name (local)',
    'Search external heroes by name (external API)',
    'Exit',
  ];
}