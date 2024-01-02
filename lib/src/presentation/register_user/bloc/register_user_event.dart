part of 'register_user_bloc.dart';

abstract class RegisterUserEvent extends Equatable {
  const RegisterUserEvent();

  @override
  List<Object> get props => [];
}
class RegisterUser extends RegisterUserEvent {
  final String phoneNumber;
  final String password;
  final String email;


  const RegisterUser(this.phoneNumber, this.password, this.email,);

  @override
  List<Object> get props => [phoneNumber, password, email];
}
