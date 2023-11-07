class AppException implements Exception {
  const AppException(this.message);
  final String? message;

  @override
  String toString() => 'App exception ($runtimeType): $message';
}
