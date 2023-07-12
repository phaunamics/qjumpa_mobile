part of 'payment_channel_bloc.dart';

abstract class PaymentChannelEvent extends Equatable {
  const PaymentChannelEvent();

  @override
  List<Object> get props => [];
}

class ChoosePaymentChannel extends PaymentChannelEvent {}
