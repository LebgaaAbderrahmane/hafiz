/// Custom exceptions for the Hafiz app.
///
/// Use in data layer. Map to failures in repository implementations.
class ServerException implements Exception {
  const ServerException({this.message, this.statusCode});
  final String? message;
  final int? statusCode;
}

class CacheException implements Exception {
  const CacheException({this.message});
  final String? message;
}

class NetworkException implements Exception {
  const NetworkException({this.message});
  final String? message;
}

class AuthException implements Exception {
  const AuthException({this.message, this.statusCode});
  final String? message;
  final int? statusCode;
}

class ValidationException implements Exception {
  const ValidationException({this.message, this.field});
  final String? message;
  final String? field;
}

class NotFoundException implements Exception {
  const NotFoundException({this.message});
  final String? message;
}

class PermissionException implements Exception {
  const PermissionException({this.message});
  final String? message;
}

class SyncException implements Exception {
  const SyncException({this.message, this.recordsAffected});
  final String? message;
  final int? recordsAffected;
}
