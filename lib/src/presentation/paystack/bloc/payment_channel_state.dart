part of 'payment_channel_bloc.dart';

abstract class PaymentChannelState extends Equatable {
  const PaymentChannelState();

  @override
  List<Object> get props => [];
}

class PaymentChannelInitial extends PaymentChannelState {}

class PaymentChannelLoading extends PaymentChannelState {}

class PaymentChannelCompleted extends PaymentChannelState {
  final Object? widget;
  const PaymentChannelCompleted({required this.widget});

  @override
  List<Object> get props => [widget!];
}

class ErrorState extends PaymentChannelState {}
