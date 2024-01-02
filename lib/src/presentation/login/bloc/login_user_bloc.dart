import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/services/user_auth_service.dart';

part 'login_user_event.dart';
part 'login_user_state.dart';

class LoginUserBloc extends Bloc<LoginUserEvent, LoginUserState> {
  final userAuthService = sl.get<UserAuthService>();
  LoginUserBloc() : super(LoginUserInitial()) {
    on<Login>((event, emit) async {
      emit(LoginUserLoading());
      try {
        await userAuthService.loginUser(
          mobileNumber: event.mobileNumber,
          password: event.password,
        );
        emit(LoginUserCompleted());
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
  }
}
