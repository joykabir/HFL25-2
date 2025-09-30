import 'package:test/test.dart';

import '../bin/calculator.dart';

void main() {
  group('SimpleCalculator Tests', () {
    late SimpleCalculator calculator;

    setUp(() {
      calculator = SimpleCalculator();
    });

    group('Calculation Tests', () {
      test('should perform addition correctly', () {
        // Test addition
        int result = calculator.performCalculation(10, 5, '+');
        expect(result, equals(15));
      });

      test('should perform subtraction correctly', () {
        // Test subtraction
        int result = calculator.performCalculation(10, 5, '-');
        expect(result, equals(5));
      });

      test('should handle negative results in subtraction', () {
        // Test negative result
        int result = calculator.performCalculation(5, 10, '-');
        expect(result, equals(-5));
      });

      test('should handle zero values', () {
        // Test with zero
        expect(calculator.performCalculation(0, 5, '+'), equals(5));
        expect(calculator.performCalculation(10, 0, '-'), equals(10));
        expect(calculator.performCalculation(0, 0, '+'), equals(0));
      });

      test('should handle large numbers', () {
        // Test with large numbers
        int result = calculator.performCalculation(1000000, 2000000, '+');
        expect(result, equals(3000000));
      });
    });

    group('Operation Name Tests', () {
      test('should return correct operation names', () {
        expect(calculator.getOperationName('+'), equals('Addition'));
        expect(calculator.getOperationName('-'), equals('Subtraction'));
        expect(calculator.getOperationName('*'), equals('Unknown Operation'));
      });
    });

    group('Error Handling Tests', () {
      test('should throw exception for unsupported operation', () {
        expect(
          () => calculator.performCalculation(10, 5, '*'),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception for invalid operation', () {
        expect(
          () => calculator.performCalculation(10, 5, '/'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });

  group('QuitException Tests', () {
    test('should create QuitException instance', () {
      QuitException exception = QuitException();
      expect(exception, isA<QuitException>());
      expect(exception, isA<Exception>());
    });
  });
}