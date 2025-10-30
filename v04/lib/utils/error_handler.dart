import 'package:v04/exceptions/api_exception.dart';
import 'package:v04/exceptions/custom_http_exception.dart';
import 'package:v04/exceptions/data_persistence_exception.dart';
import 'package:v04/exceptions/validation_exception.dart';


class ErrorHandler {
  static const String _tag = '[ERROR]';

  static String getUserMessage(Exception exception) {
    if (exception is ValidationException) {
      return '❌ Invalid input: ${exception.message}';
    }

    if (exception is CustomHttpException) {
      return '🌐 Network error: ${exception.message}';
    }

    if (exception is ApiException) {
      if (exception.statusCode == 404) {
        return '🔍 Not found: ${exception.message}';
      }
      return '⚠️  API error: ${exception.message}';
    }

    if (exception is DataPersistenceException) {
      return '💾 Storage error: ${exception.message}';
    }

    return '❌ An unexpected error occurred: ${exception.toString()}';
  }

  static Exception handleError(
    dynamic error, {
    bool verbose = false,
    String context = 'Operation',
  }) {
    if (verbose) {
      print('$_tag Error in $context: $error (${error.runtimeType})');
    }

    if (error is CustomHttpException) {
      return error;
    }

    if (error is ValidationException) {
      return error;
    }

    if (error is DataPersistenceException) {
      return error;
    }

    if (error is ApiException) {
      return error;
    }

    if (error is FormatException) {
      return ApiException(
        'Invalid JSON format',
        originalError: error,
      );
    }

    if (error is CustomHttpException) {
      return ApiException(
        'Network error: ${error.message}',
        originalError: error,
      );
    }

    // Default: wrap as generic API exception
    return ApiException(
      'Unexpected error: $error',
      originalError: error,
    );
  }

  static void logError(
    String message, {
    dynamic error,
    bool verbose = false,
  }) {
    if (verbose) {
      print('$_tag $message');
      if (error != null) {
        print('$_tag Cause: $error');
      }
    }
  }
}