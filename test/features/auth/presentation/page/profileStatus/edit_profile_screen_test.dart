import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_book_access/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_book_access/features/auth/domain/usecase/update_profile_usecase.dart';
import 'package:smart_book_access/features/auth/presentation/page/profileStatus/edit_profile_screen.dart';
import 'package:smart_book_access/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:smart_book_access/features/auth/presentation/state/auth_state.dart';

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class FakeAuthViewModel extends AuthViewModel {
  final AuthEntity user;
  final UpdateProfileUsecase updateUsecase;

  FakeAuthViewModel({required this.user, required this.updateUsecase});

  @override
  AuthState build() {
    return AuthState(status: AuthStatus.authenticated, authEntity: user);
  }

  @override
  Future<void> updateProfile({
    required String username,
    required String email,
    required String countryCode,
    required String phone,
    File? imageUrl,
  }) async {
    await updateUsecase(
      UpdateProfileUsecaseParams(
        username: username,
        email: email,
        countryCode: countryCode,
        phone: phone,
      ),
    );
  }
}

void main() {
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;

  final tAuthEntity = const AuthEntity(
    authId: '123',
    username: 'John Doe',
    email: 'john@gmail.com',
    phone: '9841234567',
    countryCode: '+977',
  );

  setUpAll(() {
    registerFallbackValue(
      const UpdateProfileUsecaseParams(
        username: 'fallback',
        email: 'fallback@email.com',
        countryCode: '+977',
        phone: '9841234567',
      ),
    );
  });

  setUp(() {
    mockUpdateProfileUsecase = MockUpdateProfileUsecase();

    when(
      () => mockUpdateProfileUsecase(any()),
    ).thenAnswer((_) async => const Right(true));
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        authViewModelProvider.overrideWith(
          () => FakeAuthViewModel(
            user: tAuthEntity,
            updateUsecase: mockUpdateProfileUsecase,
          ),
        ),
      ],
      child: const MaterialApp(home: EditProfileScreen()),
    );
  }

  group('EditProfileScreen Essential Tests', () {
    // TEST 1: Initial State
    testWidgets('should display current user information in text fields', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@gmail.com'), findsOneWidget);
      expect(find.text('9841234567'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    // TEST 2: Update Submission
    testWidgets(
      'should call updateProfile usecase when the edit button is pressed',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1600));
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final nameField = find.byType(TextFormField).first;
        await tester.enterText(nameField, 'John Updated');
        await tester.pump();

        final updateButton = find.widgetWithText(
          ElevatedButton,
          'Edit Profile',
        );
        await tester.tap(updateButton);
        await tester.pumpAndSettle();

        // Verify
        verify(() => mockUpdateProfileUsecase(any())).called(1);

        await tester.binding.setSurfaceSize(null);
      },
    );
  });
}
