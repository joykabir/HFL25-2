import 'package:v04/exceptions/api_exception.dart';
import 'package:v04/handlers/http_handler.dart';
import 'package:v04/handlers/http_handler_interface.dart';
import 'package:v04/models/heromodel.dart';
// ignore: unused_import
import 'test_data_factory.dart';

class MockHttpHandler implements HttpHandlerInterface {
  final List<HeroModel> _mockApiResults = [];
  bool _shouldThrowError = false;

  // Add mock data for testing
  void addMockResult(HeroModel hero) {
    _mockApiResults.add(hero);
  }

  void clearMockResults() {
    _mockApiResults.clear();
  }

  void setShouldThrowError(bool shouldThrow) {
    _shouldThrowError = shouldThrow;
  }

  @override
  Future<List<HeroModel>> getHeroesByName(String name, {bool verbose = false}) async {
    if (_shouldThrowError) {
      throw ApiException('Mock API error');
    }

    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 100));

    // Return filtered mock results
    return _mockApiResults
        .where((hero) => hero.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  @override
  Future<HeroModel?> getHeroDetailsById(String externalId, {bool verbose = false}) async {
    if (_shouldThrowError) {
      throw ApiException('Mock API error');
    }

    await Future.delayed(Duration(milliseconds: 100));

    return _mockApiResults
        .where((hero) => hero.externalId == externalId)
        .firstOrNull;
  }

  @override
  Future<bool> testConnection({bool verbose = false}) async {
    await Future.delayed(Duration(milliseconds: 50));
    return !_shouldThrowError;
  }
}