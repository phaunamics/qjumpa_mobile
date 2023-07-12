import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payment_channel_event.dart';
part 'payment_channel_state.dart';

class PaymentChannelBloc
    extends Bloc<PaymentChannelEvent, PaymentChannelState> {
  PaymentChannelBloc() : super(PaymentChannelInitial()) {
    on<ChoosePaymentChannel>((event, emit) {
      // TODO: implement event handler
    });
  }
}
