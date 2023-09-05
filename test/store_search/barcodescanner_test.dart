import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';
import 'package:qjumpa/src/domain/usecases/get_inventory_usecase.dart';
import 'package:qjumpa/src/presentation/store_search/bloc/barcodescanner_bloc.dart';

// Create a mock for the GetInventoryUseCase
class MockGetInventoryUseCase extends Mock implements GetInventoryUseCase {}

void main() {
  group('BarcodeScannerBloc', () {
    late BarcodeScannerBloc barcodeScannerBloc;
    late MockGetInventoryUseCase mockGetInventoryUseCase;

    setUp(() {
      mockGetInventoryUseCase = MockGetInventoryUseCase();
      barcodeScannerBloc = BarcodeScannerBloc();
    });

    tearDown(() {
      barcodeScannerBloc.close();
    });

    test('initial state is BarcodescannerInitial', () {
      expect(barcodeScannerBloc.state, equals(BarcodescannerInitial()));
    });

    blocTest<BarcodeScannerBloc, BarcodescannerState>(
      'emits [BarcodescannerCompleted] when successful',
      build: () {
        // Set up the mock behavior for getInventoryUseCase
        when(mockGetInventoryUseCase.call(any)).thenAnswer((_) async => [
              Inventory(sku: '123', name: 'Item 1'),
              Inventory(sku: '456', name: 'Item 2'),
            ]);

        return BarcodeScannerBloc();
      },
      act: (bloc) => bloc.add(const Scan(id: 'storeId')),
      expect: () => [
        // You can adjust the expected states based on your actual logic
        BarcodescannerCompleted(
            inventory: Inventory(sku: '123', name: 'Item 1')),
      ],
    );

    blocTest<BarcodeScannerBloc, BarcodescannerState>(
      'emits [BarcodescannerError] when an exception is thrown',
      build: () {
        // Set up the mock behavior for getInventoryUseCase
        when(mockGetInventoryUseCase.call(any)).thenThrow(Exception());

        return BarcodeScannerBloc();
      },
      act: (bloc) => bloc.add(const Scan(id: 'storeId')),
      expect: () => [
        const BarcodescannerError('Something went wrong'),
      ],
    );

    // Add more tests to cover other scenarios if needed
  });
}
