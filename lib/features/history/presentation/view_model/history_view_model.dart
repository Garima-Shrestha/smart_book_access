import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/features/history/domain/usecase/get_my_history_usecase.dart';
import 'package:smart_book_access/features/history/presentation/state/history_state.dart';

final historyViewModelProvider =
NotifierProvider<HistoryViewModel, HistoryState>(() => HistoryViewModel());

class HistoryViewModel extends Notifier<HistoryState> {
  late final GetMyHistoryUsecase _getMyHistoryUsecase;

  @override
  HistoryState build() {
    _getMyHistoryUsecase = ref.read(getMyHistoryUsecaseProvider);
    return const HistoryState();
  }

  Future<void> getMyHistory({
    required int page,
    required int size,
  }) async {
    state = state.copyWith(status: HistoryStatus.loading, errorMessage: null);

    final params = GetMyHistoryUsecaseParams(page: page, size: size);
    final result = await _getMyHistoryUsecase.call(params);

    result.fold(
          (failure) {
        state = state.copyWith(
          status: HistoryStatus.error,
          errorMessage: failure.message,
        );
      },
          (historyList) {
        state = state.copyWith(
          status: HistoryStatus.loaded,
          historyList: historyList,
          errorMessage: null,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}