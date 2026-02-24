import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/features/library/domain/usecase/get_my_library_usecase.dart';
import 'package:smart_book_access/features/library/presentation/state/my_library_state.dart';

final myLibraryViewModelProvider =
NotifierProvider<MyLibraryViewModel, MyLibraryState>(
      () => MyLibraryViewModel(),
);

class MyLibraryViewModel extends Notifier<MyLibraryState> {
  late final GetMyLibraryUsecase _getMyLibraryUsecase;

  @override
  MyLibraryState build() {
    _getMyLibraryUsecase = ref.read(getMyLibraryUsecaseProvider);
    Future.microtask(() => fetchMyLibrary());
    return const MyLibraryState();
  }

  Future<void> fetchMyLibrary({int page = 1, int size = 10}) async {
    state = state.copyWith(status: MyLibraryStatus.loading, errorMessage: null);

    final params = GetMyLibraryUsecaseParams(page: page, size: size);
    final result = await _getMyLibraryUsecase.call(params);

    result.fold(
          (failure) {
        state = state.copyWith(
          status: MyLibraryStatus.error,
          errorMessage: failure.message,
        );
      },
          (books) {
        state = state.copyWith(
          status: MyLibraryStatus.loaded,
          books: books,
          errorMessage: null,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}