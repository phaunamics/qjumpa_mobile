part of 'barcodescanner_bloc.dart';

abstract class BarcodescannerState extends Equatable {
  const BarcodescannerState();

  @override
  List<Object> get props => [];
}

class BarcodescannerInitial extends BarcodescannerState {}

class BarcodescannerLoading extends BarcodescannerState {}

class BarcodescannerCompleted extends BarcodescannerState {
  final Inventory inventory;

  const BarcodescannerCompleted({required this.inventory});
  @override
  List<Object> get props => [inventory];
}

class BarcodescannerError extends BarcodescannerState {
  final String message;

  const BarcodescannerError(this.message);
  @override
  List<Object> get props => [message];
}
