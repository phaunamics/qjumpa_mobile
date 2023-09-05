import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';
import 'package:qjumpa/src/domain/usecases/get_inventory_usecase.dart';

part 'barcodescanner_event.dart';
part 'barcodescanner_state.dart';

class BarcodeScannerBloc
    extends Bloc<BarcodescannerEvent, BarcodescannerState> {
  final getInventoryUseCase = sl.get<GetInventoryUseCase>();
  Future<String?> scanBarcode() async {
    try {
      var scanResult = await BarcodeScanner.scan(
          options: const ScanOptions(
        strings: {
          'cancel': 'Cancel',
          'flash_on': 'Flash on',
          'flash_off': 'Flash off'
        },
      ));
      return scanResult.rawContent;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
      } else {
        debugPrint('Error:$e');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  Inventory? performBarcodeSearch(String barcode, List<Inventory> list) {
    for (var item in list) {
      if (item.sku == barcode) {
        return item;
      }
    }
    return null;
  }

  BarcodeScannerBloc() : super(BarcodescannerInitial()) {
    on<Scan>((event, emit) async {
      try {
        var inventory = await getInventoryUseCase.call(event.id);
        var result = await scanBarcode();
        var searchResult = performBarcodeSearch(result!, inventory);
        emit(BarcodescannerCompleted(inventory: searchResult!));
      } on Exception {
        emit(const BarcodescannerError('Something went wrong'));
      }
    });
  }
}
