class AuthException implements Exception {
  /// Creates an exception with message describing the reason.
  AuthException(this.message);

  /// The reason that causes this exception.
  final String message;

  @override
  String toString() => 'Authentication: $message';
}
