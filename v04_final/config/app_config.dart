import 'package:dotenv/dotenv.dart';

class AppConfig {
  static AppConfig? _instance;
  
  static AppConfig get instance {
    return _instance ??= AppConfig._loadFromEnv();
  }
  final String apiUrl;

  final String apiKey;

  AppConfig._({
    required this.apiUrl,
    required this.apiKey,
  });

  String buildApiUrl([String endpoint = '']) {
    if (endpoint.isEmpty) {
      return '$apiUrl/$apiKey';
    }
    return '$apiUrl/$apiKey/$endpoint';
  }

  static AppConfig _loadFromEnv() {
    final env = DotEnv();
    
    // don't crash if not found
    try {
      env.load(['../.env']);
    } catch (_) {
      // Silently continue
    }

    final apiKey = env['SUPERHERO_API_KEY'];
    final apiUrl = env['SUPERHERO_API_URL'] ?? 'https://superheroapi.com/api';

    if (apiKey?.isEmpty ?? true) {
      throw Exception('Missing SUPERHERO_API_KEY in environment or .env file');
    }

    return AppConfig._(
      apiUrl: apiUrl,
      apiKey: apiKey!,
    );
  }
}