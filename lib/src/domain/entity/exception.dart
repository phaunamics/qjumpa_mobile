// ignore_for_file: public_member_api_docs, sort_constructors_first
class ServerError {
  final String message;

  ServerError({required this.message});

  @override
  String toString() {
    return 'Server error{message: $message}';
  }
}

class NoInternetException {
  final String message;
  final String? subText;

  NoInternetException({required this.message, this.subText});
  @override
  String toString() {
    return 'No Internet{message: $message}';
  }
}

class NoServiceFoundException {
  String message;
  NoServiceFoundException({required this.message});
}

class UnknownException {
  String message;
  UnknownException({required this.message});
}

class UnAuthorizedAccessException {
  String message;
  UnAuthorizedAccessException({required this.message});
}

class InvalidCredentialsException {
  String message;
  
  InvalidCredentialsException({required this.message});

  @override
  String toString() => 'InvalidCredentialsException(message: $message)';
}
