import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/services/user_auth_service.dart';

part 'register_user_event.dart';
part 'register_user_state.dart';

class RegisterUserBloc extends Bloc<RegisterUserEvent, RegisterUserState> {
  final userService = sl.get<UserAuthService>();
  RegisterUserBloc() : super(RegisterUserInitial()) {
    on<RegisterUser>((event, emit) async {
      emit(RegisterUserLoading());
      try {
        await userService.registerUser(
            phoneNumber: event.phoneNumber,
            password: event.password,
            email: event.email);
        emit(const RegisterUserCompleted());
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
  }
}
