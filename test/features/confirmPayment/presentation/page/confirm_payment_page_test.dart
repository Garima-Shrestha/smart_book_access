import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:smart_book_access/features/confirmPayment/presentation/page/confirm_payment_page.dart';
import 'package:smart_book_access/features/confirmPayment/presentation/state/confirm_payment_state.dart';
import 'package:smart_book_access/features/confirmPayment/presentation/view_model/confirm_payment_view_model.dart';
import 'package:smart_book_access/features/khalti/domain/usecase/initiate_khalti_usecase.dart';
import 'package:smart_book_access/features/khalti/domain/usecase/verify_khalti_usecase.dart';
import 'package:smart_book_access/core/widgets/my_button.dart';

class MockInitiateKhaltiUsecase extends Mock implements InitiateKhaltiUsecase {}

class MockVerifyKhaltiUsecase extends Mock implements VerifyKhaltiUsecase {}

const tBook = BookEntity(
  bookId: 'book_1',
  title: 'Test Book',
  author: 'Test Author',
  description: 'A test description',
  genre: 'cat_1',
  pages: 200,
  price: 500,
  publishedDate: '2024-01-01',
  coverImageUrl: '',
);

void main() {
  late MockInitiateKhaltiUsecase mockInitiateUsecase;
  late MockVerifyKhaltiUsecase mockVerifyUsecase;

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
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        initiateKhaltiUsecaseProvider.overrideWithValue(mockInitiateUsecase),
        verifyKhaltiUsecaseProvider.overrideWithValue(mockVerifyUsecase),
        confirmPaymentViewModelProvider.overrideWith(
          () => _FakeConfirmPaymentViewModel(),
        ),
      ],
      child: const MaterialApp(home: ConfirmPaymentPage(book: tBook)),
    );
  }

  group('ConfirmPaymentPage Widget Tests', () {
    testWidgets('should display book title and author', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(createTestWidget());
      // Use pump with duration instead of pumpAndSettle to avoid image timeout
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Test Book'), findsOneWidget);
      expect(find.text('Test Author'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should display PAY WITH KHALTI button and date selector', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.widgetWithText(MyButton, 'PAY WITH KHALTI'), findsOneWidget);
      expect(find.text('Select Date'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });
  });
}

class _FakeConfirmPaymentViewModel extends ConfirmPaymentViewModel {
  @override
  ConfirmPaymentState build() => const ConfirmPaymentState();
}
