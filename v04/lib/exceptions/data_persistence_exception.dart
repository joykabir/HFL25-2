/// Custom exception for local data storage/retrieval errors
class DataPersistenceException implements Exception {
  final String message;
  final dynamic originalError;

  DataPersistenceException(this.message, [this.originalError]);

  @override
  String toString() => 'DataPersistenceException: $message${originalError != null ? '\nCause: $originalError' : ''}';
}