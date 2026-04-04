/// Base exception class for all SideQuest application exceptions.
///
/// Provides a consistent interface for error handling across the app.
/// Use specific subclasses for different error categories.
class AppException implements Exception {
  /// Creates an [AppException] with the given [message] and optional [code].
  const AppException(this.message, {this.code});

  /// Human-readable description of the error.
  final String message;

  /// Optional error code for programmatic handling.
  final String? code;

  @override
  String toString() => 'AppException($code): $message';
}

/// Exception thrown when a network request fails.
class NetworkException extends AppException {
  /// Creates a [NetworkException].
  const NetworkException([
    super.message = 'A network error occurred. Please check your connection.',
  ]) : super(code: 'network_error');
}

/// Exception thrown when authentication fails.
class AuthException extends AppException {
  /// Creates an [AuthException].
  const AuthException([
    super.message = 'Authentication failed. Please try again.',
  ]) : super(code: 'auth_error');
}

/// Exception thrown when a requested resource is not found.
class NotFoundException extends AppException {
  /// Creates a [NotFoundException].
  const NotFoundException([
    super.message = 'The requested resource was not found.',
  ]) : super(code: 'not_found');
}

/// Exception thrown when the user lacks permission for an action.
class PermissionException extends AppException {
  /// Creates a [PermissionException].
  const PermissionException([
    super.message = 'You do not have permission to perform this action.',
  ]) : super(code: 'permission_denied');
}
