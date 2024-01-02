part of 'login_user_bloc.dart';

abstract class LoginUserEvent extends Equatable {
  const LoginUserEvent();

  @override
  List<Object> get props => [];
}

class Login extends LoginUserEvent {
  final String mobileNumber;
  final String password;

  const Login({required this.mobileNumber, required this.password});
}
