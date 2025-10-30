import 'dart:io';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:path/path.dart' as p;

class AppConfig {
  static AppConfig? _instance;
  static String? _cachedApiKey;
  static String? _cachedApiUrl;

  static const String envFileName = '.env';
  static const String defaultApiUrl = 'https://superheroapi.com/api';

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
    // Build absolute path to .env in project root
    final envPath = p.join(Directory.current.path, envFileName);
    final envFile = File(envPath);

    print('[INFO] Looking for .env at: $envPath');

    if (!envFile.existsSync()) {
      throw Exception(
        'Error: .env file not found at: $envPath\n'
        'Please ensure .env exists in your project root (HFL25-2/v04)'
      );
    }

    try {
      final env = dotenv.DotEnv(includePlatformEnvironment: true);
      env.load([envPath]);

      _cachedApiKey = env['SUPERHERO_API_KEY'];
      _cachedApiUrl = env['SUPERHERO_API_URL'];

      if (_cachedApiKey?.isEmpty ?? true) {
        throw Exception(
          'Error: SUPERHERO_API_KEY is missing or empty in .env file'
        );
      }

      print('[INFO] ✅ .env file loaded successfully');
      print('[INFO] API URL: ${_cachedApiUrl ?? defaultApiUrl}');

      return AppConfig._(
        apiUrl: _cachedApiUrl ?? defaultApiUrl,
        apiKey: _cachedApiKey!,
      );
    } catch (e) {
      print('[ERROR] Failed to load .env: $e');
      rethrow;
    }
  }
}