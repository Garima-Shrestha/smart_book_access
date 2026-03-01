import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/khalti/domain/entities/khalti_entity.dart';
import 'package:smart_book_access/features/khalti/domain/usecase/initiate_khalti_usecase.dart';
import 'package:smart_book_access/features/khalti/domain/usecase/verify_khalti_usecase.dart';
import 'package:smart_book_access/features/khalti/presentation/state/khalti_state.dart';
import 'package:smart_book_access/features/khalti/presentation/view_model/khalti_view_model.dart';

class MockInitiateKhaltiUsecase extends Mock implements InitiateKhaltiUsecase {}

class MockVerifyKhaltiUsecase extends Mock implements VerifyKhaltiUsecase {}

class MockFailure extends Failure {
  const MockFailure(super.message);
}

void main() {
  late MockInitiateKhaltiUsecase mockInitiateUsecase;
  late MockVerifyKhaltiUsecase mockVerifyUsecase;
  late ProviderContainer container;

  const tInitiateResponse = KhaltiInitiateResponseEntity(
    pidx: 'pidx_123',
    paymentUrl: 'https://test-pay.khalti.com/?pidx=pidx_123',
    expiresAt: '2024-01-01T00:00:00Z',
  );

  const tVerifyResponse = KhaltiVerifyResponseEntity(
    status: 'Completed',
    bookAccessId: 'access_123',
  );

  setUpAll(() {
    registerFallbackValue(
      const InitiateKhaltiUsecaseParams(
        bookId: '',
        amount: 0,
        purchaseOrderId: '',
        purchaseOrderName: '',
      ),
    );
    registerFallbackValue(const VerifyKhaltiUsecaseParams(pidx: ''));
  });

  setUp(() {
    mockInitiateUsecase = MockInitiateKhaltiUsecase();
    mockVerifyUsecase = MockVerifyKhaltiUsecase();

    container = ProviderContainer(
      overrides: [
        initiateKhaltiUsecaseProvider.overrideWithValue(mockInitiateUsecase),
        verifyKhaltiUsecaseProvider.overrideWithValue(mockVerifyUsecase),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('KhaltiViewModel', () {
    test('should emit initiated state when initiatePayment succeeds', () async {
      when(
        () => mockInitiateUsecase(any()),
      ).thenAnswer((_) async => const Right(tInitiateResponse));

      final viewModel = container.read(khaltiViewModelProvider.notifier);
      await viewModel.initiatePayment(
        bookId: 'book_1',
        amount: 1000,
        purchaseOrderId: 'order_1',
        purchaseOrderName: 'Test Book',
      );

      final state = container.read(khaltiViewModelProvider);
      expect(state.status, KhaltiStatus.initiated);
      expect(state.initiateResponse, tInitiateResponse);
      expect(state.errorMessage, isNull);
      verify(() => mockInitiateUsecase(any())).called(1);
    });

    test('should emit completed state when verifyPayment succeeds', () async {
      when(
        () => mockVerifyUsecase(any()),
      ).thenAnswer((_) async => const Right(tVerifyResponse));

      final viewModel = container.read(khaltiViewModelProvider.notifier);
      await viewModel.verifyPayment(pidx: 'pidx_123');

      final state = container.read(khaltiViewModelProvider);
      expect(state.status, KhaltiStatus.completed);
      expect(state.verifyResponse, tVerifyResponse);
      expect(state.errorMessage, isNull);
      verify(() => mockVerifyUsecase(any())).called(1);
    });
  });
}
