import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/features/splash/domain/usecase/get_initialpage_usecase.dart';
import '../state/splash_state.dart';

final splashViewModelProvider = NotifierProvider<SplashViewModel, SplashState>(
      () => SplashViewModel(),
);

class SplashViewModel extends Notifier<SplashState> {
  late final GetInitialPageUsecase _getInitialPageUsecase;

  @override
  SplashState build() {
    _getInitialPageUsecase = ref.read(getInitialPageUsecaseProvider);
    return SplashState(); // initial State
  }

  Future<void> checkInitialPage() async {
    state = state.copyWith(status: SplashStatus.loading);

    final result = await _getInitialPageUsecase.call();

    result.fold(
        (failure) {
          state = state.copyWith(
            status: SplashStatus.error,
            errorMessage: failure.message,
          );
        }, (isLoggedIn) {
            state = state.copyWith(
              status: SplashStatus.success,
              isLoggedIn: isLoggedIn,
            );
    });
  }
}