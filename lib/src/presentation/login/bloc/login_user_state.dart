part of 'login_user_bloc.dart';

abstract class LoginUserState extends Equatable {
  const LoginUserState();
  
  @override
  List<Object> get props => [];
}


class LoginUserInitial extends LoginUserState {}
class LoginUserLoading extends LoginUserState {}
class LoginUserCompleted extends LoginUserState {}
class ErrorState extends LoginUserState {
  final String messsge;

  const ErrorState(this.messsge);
}
