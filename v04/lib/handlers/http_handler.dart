import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:v04/exceptions/api_exception.dart';
import 'package:v04/config/app_config.dart';
import 'package:v04/config/constants.dart';
import 'package:v04/exceptions/custom_http_exception.dart';
import 'package:v04/handlers/http_handler_interface.dart';
import 'package:v04/mappers/hero_mapper.dart';
import 'package:v04/exceptions/validation_exception.dart';

import '../models/heromodel.dart';

class HttpHandler implements HttpHandlerInterface {
  static final HttpHandler _instance = HttpHandler._internal();
  late final String _baseUrl;
  late final String _apiKey;

  factory HttpHandler() {
    return _instance;
  }

  HttpHandler._internal() {
    final config = AppConfig.instance;
    _baseUrl = config.apiUrl;
    _apiKey = config.apiKey;
  }

  @override
  Future<HeroModel?> getHeroDetailsById(String externalId, {bool verbose = false}) async {
    if (externalId.trim().isEmpty) {
      throw ValidationException('Hero ID cannot be empty', 'externalId');
    }

    final url = _buildApiUrl(externalId.trim());

    try {
      if (verbose) {
        print('[DEBUG] Fetching hero details from: $url');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: AppConstants.defaultHttpHeaders,
      ).timeout(AppConstants.httpTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['response'] == 'success') {
          // Use HeroMapper to transform API response to HeroModel format
          final transformedJson = HeroMapper.fromApiJson(data);
          return HeroModel.fromJson(transformedJson);
        } else {
          throw ApiException(data['error'] ?? 'Unknown API error');
        }
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw ApiException(
          '${response.reasonPhrase}',
          statusCode: response.statusCode,
        );
      }
    } on FormatException catch (e) {
      throw ApiException('Invalid JSON response', originalError: e);
    } on http.ClientException catch (e) {
      throw CustomHttpException('Network error: $e');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HeroModel>> getHeroesByName(String name, {bool verbose = false}) async {
    if (name.trim().isEmpty) {
      throw ValidationException('Hero name cannot be empty', 'name');
    }

    final searchEndpoint = '${AppConstants.searchEndpoint}/${Uri.encodeComponent(name.trim())}';
    final url = _buildApiUrl(searchEndpoint);
    print('Fetching heroes by name from URL: $url');
    try {
      if (verbose) {
        print('[DEBUG] Fetching from: $url');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: AppConstants.defaultHttpHeaders,
      ).timeout(AppConstants.httpTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Check API response status
        if (data['response'] == 'error') {
          throw ApiException(
            data['error'] ?? 'Unknown API error',
            statusCode: 400,
          );
        }

        if (data['response'] == 'success' && data.containsKey('results')) {
          final List<dynamic> results = data['results'];

          if (results.isEmpty) {
            if (verbose) {
              print('[DEBUG] No results found for: $name');
            }
            return [];
          }

          // Use HeroMapper to transform API response to HeroModel format
          // Then use HeroModel.fromJson() for deserialization
          return results
              .map((heroJson) {
                final transformedJson = HeroMapper.fromApiJson(heroJson as Map<String, dynamic>);
                return HeroModel.fromJson(transformedJson);
              })
              .toList();
        } else {
          throw ApiException('Unexpected API response structure');
        }
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw ApiException(
          '${response.reasonPhrase}',
          statusCode: response.statusCode,
        );
      }
    } on FormatException catch (e) {
      throw ApiException('Invalid JSON response', originalError: e);
    } on http.ClientException catch (e) {
      throw CustomHttpException('Network error: $e');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> testConnection({bool verbose = false}) async {
    try {
      if (verbose) {
        print('[TEST] 🔗 Testing API connection...');
        print('[TEST] URL: $_baseUrl');
        print('[TEST] API Key: ${_apiKey.substring(0, 5)}...${_apiKey.substring(_apiKey.length - 5)}');
      }

      final heroes = await getHeroesByName('batman', verbose: verbose);

      if (heroes.isNotEmpty) {
        if (verbose) {
          print('[TEST] ✅ Connection successful!');
          print('[TEST] Retrieved ${heroes.length} hero(es) from API');
        }
        return true;
      } else {
        if (verbose) {
          print('[TEST] ⚠️  Connection OK but no heroes returned');
        }
        return false;
      }
    } catch (e) {
      if (verbose) {
        print('[TEST] ❌ Connection failed: $e');
      }
      return false;
    }
  }

  String _buildApiUrl(String endpoint) {
    return '$_baseUrl/$_apiKey/$endpoint';
  }
}