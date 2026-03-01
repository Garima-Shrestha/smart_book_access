import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/khalti/domain/entities/khalti_entity.dart';
import 'package:smart_book_access/features/khalti/domain/repositories/khalti_repository.dart';
import 'package:smart_book_access/features/khalti/domain/usecase/initiate_khalti_usecase.dart';

class MockKhaltiRepository extends Mock implements IKhaltiRepository {}

class MockFailure extends Failure {
  const MockFailure() : super('Failed to initiate payment');
}

void main() {
  late InitiateKhaltiUsecase usecase;
  late MockKhaltiRepository mockRepository;

  setUp(() {
    mockRepository = MockKhaltiRepository();
    usecase = InitiateKhaltiUsecase(khaltiRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const KhaltiPaymentEntity(
        bookId: '',
        amount: 0,
        purchaseOrderId: '',
        purchaseOrderName: '',
      ),
    );
  });

  const tParams = InitiateKhaltiUsecaseParams(
    bookId: 'book_1',
    amount: 1000,
    purchaseOrderId: 'order_1',
    purchaseOrderName: 'Test Book',
  );

  const tResponse = KhaltiInitiateResponseEntity(
    pidx: 'pidx_123',
    paymentUrl: 'https://test-pay.khalti.com/?pidx=pidx_123',
    expiresAt: '2024-01-01T00:00:00Z',
  );

  group('InitiateKhaltiUsecase', () {
    test(
      'should return Right(KhaltiInitiateResponseEntity) when initiation succeeds',
      () async {
        when(
          () => mockRepository.initiatePayment(any()),
        ).thenAnswer((_) async => const Right(tResponse));

        final result = await usecase(tParams);

        expect(result, const Right(tResponse));
        verify(() => mockRepository.initiatePayment(any())).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return Left(Failure) when initiation fails', () async {
      const tFailure = MockFailure();
      when(
        () => mockRepository.initiatePayment(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockRepository.initiatePayment(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
