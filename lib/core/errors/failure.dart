/// Sealed class representing expected failures from repository operations.
///
/// Used with the Either pattern to distinguish expected errors
/// from unexpected exceptions. All repository methods return
/// `Either<Failure, T>` for expected error cases.
sealed class Failure {
  /// Creates a [Failure] with the given [message].
  const Failure(this.message);

  /// Human-readable description of the failure.
  final String message;
}

/// Failure caused by network connectivity issues.
class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure].
  const NetworkFailure([
    super.message = 'Network error. Check your connection.',
  ]);
}

/// Failure caused by authentication issues.
class AuthFailure extends Failure {
  /// Creates an [AuthFailure].
  const AuthFailure([super.message = 'Authentication failed.']);
}

/// Failure when a requested resource does not exist.
class NotFoundFailure extends Failure {
  /// Creates a [NotFoundFailure].
  const NotFoundFailure([super.message = 'Not found.']);
}

/// Failure when the user lacks required permissions.
class PermissionFailure extends Failure {
  /// Creates a [PermissionFailure].
  const PermissionFailure([
    super.message = "You don't have permission.",
  ]);
}

/// Failure caused by invalid input or business rule violation.
class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure] with a specific [message].
  const ValidationFailure(super.message);
}
