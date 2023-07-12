part of 'barcodescanner_bloc.dart';

abstract class BarcodescannerEvent extends Equatable {
  const BarcodescannerEvent();

  @override
  List<Object> get props => [];
}

class Scan extends BarcodescannerEvent {
  @override
  List<Object> get props => [];
}
