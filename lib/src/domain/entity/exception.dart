class ServerError implements Exception {
  final String message;

  ServerError({required this.message});
  @override
  String toString() {
    return 'server error{message: $message}';
  }
}

class NoInternetException implements Exception {
  final String message;

  NoInternetException({required this.message});
  @override
  String toString() {
    return 'NoInternet{message: $message}';
  }
}
