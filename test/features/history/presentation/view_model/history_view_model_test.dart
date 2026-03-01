import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/history/domain/entities/history_entity.dart';
import 'package:smart_book_access/features/history/domain/usecase/get_my_history_usecase.dart';
import 'package:smart_book_access/features/history/presentation/state/history_state.dart';
import 'package:smart_book_access/features/history/presentation/view_model/history_view_model.dart';

class MockGetMyHistoryUsecase extends Mock implements GetMyHistoryUsecase {}

class MockFailure extends Failure {
  const MockFailure(super.message);
}

void main() {
  late MockGetMyHistoryUsecase mockGetMyHistoryUsecase;
  late ProviderContainer container;

  final tHistoryList = [
    HistoryEntity(
      accessId: 'access_1',
      bookId: 'book_1',
      title: 'Test Book',
      author: 'Test Author',
      pages: 100,
      rentedAt: DateTime(2024, 1, 1),
      expiresAt: DateTime(2024, 1, 8),
      isExpired: true,
      isInactive: true,
      canReRent: true,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(const GetMyHistoryUsecaseParams(page: 1, size: 10));
  });

  setUp(() {
    mockGetMyHistoryUsecase = MockGetMyHistoryUsecase();

    container = ProviderContainer(
      overrides: [
        getMyHistoryUsecaseProvider.overrideWithValue(mockGetMyHistoryUsecase),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('HistoryViewModel', () {
    test('should emit loaded state when getMyHistory succeeds', () async {
      when(
        () => mockGetMyHistoryUsecase(any()),
      ).thenAnswer((_) async => Right(tHistoryList));

      final viewModel = container.read(historyViewModelProvider.notifier);
      await viewModel.getMyHistory(page: 1, size: 10);

      final state = container.read(historyViewModelProvider);
      expect(state.status, HistoryStatus.loaded);
      expect(state.historyList, tHistoryList);
      verify(() => mockGetMyHistoryUsecase(any())).called(1);
    });

    test('should emit error state when getMyHistory fails', () async {
      const tFailure = MockFailure('Failed to fetch history');
      when(
        () => mockGetMyHistoryUsecase(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final viewModel = container.read(historyViewModelProvider.notifier);
      await viewModel.getMyHistory(page: 1, size: 10);

      final state = container.read(historyViewModelProvider);
      expect(state.status, HistoryStatus.error);
      expect(state.errorMessage, 'Failed to fetch history');
    });
  });
}
