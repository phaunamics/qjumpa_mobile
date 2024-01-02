// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'register_user_bloc.dart';

abstract class RegisterUserState extends Equatable {
  const RegisterUserState();

  @override
  List<Object> get props => [];
}

class RegisterUserInitial extends RegisterUserState {}

class RegisterUserLoading extends RegisterUserState {
  @override
  List<Object> get props => [];
}

class RegisterUserCompleted extends RegisterUserState {
  const RegisterUserCompleted();
  @override
  List<Object> get props => [];
}

class ErrorState extends RegisterUserState {
  final String message;

  const ErrorState(this.message);
  @override
  List<Object> get props => [];
}
