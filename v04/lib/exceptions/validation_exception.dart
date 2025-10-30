/// Custom exception for input validation errors
class ValidationException implements Exception {
  final String message;
  final String? field;

  ValidationException(this.message, [this.field]);

  @override
  String toString() => 'ValidationException: $message${field != null ? ' (Field: $field)' : ''}';
}