import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ios_bar_scanner_event.dart';
part 'ios_bar_scanner_state.dart';

class IosBarScannerBloc extends Bloc<IosBarScannerEvent, IosBarScannerState> {
  IosBarScannerBloc() : super(IosBarScannerInitial()) {
    on<IosBarScannerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
