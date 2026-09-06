import 'package:equatable/equatable.dart';

/// Base failure class.
///
/// Use in domain layer to represent errors.
/// Repository implementations map exceptions to failures.
abstract class Failure extends Equatable {
  const Failure({this.message, this.stackTrace});
  final String? message;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, stackTrace];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message, this.statusCode});
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  const CacheFailure({super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message, this.statusCode});
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message, this.field});
  final String? field;

  @override
  List<Object?> get props => [message, field];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message});
}

class PermissionFailure extends Failure {
  const PermissionFailure({super.message});
}

class SyncFailure extends Failure {
  const SyncFailure({super.message, this.recordsAffected});
  final int? recordsAffected;

  @override
  List<Object?> get props => [message, recordsAffected];
}
