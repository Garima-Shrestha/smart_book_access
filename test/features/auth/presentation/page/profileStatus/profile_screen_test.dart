import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/features/auth/domain/usecase/login_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/logout_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/register_usecase.dart';
import 'package:smart_book_access/features/auth/domain/usecase/update_profile_usecase.dart';
import 'package:smart_book_access/features/auth/presentation/page/profileStatus/profile_screen.dart';
import 'package:smart_book_access/core/services/storage/user_session_service.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockLogoutUsecase mockLogoutUsecase;
  late MockUserSessionService mockSessionService;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;

  setUp(() {
    mockLogoutUsecase = MockLogoutUsecase();
    mockSessionService = MockUserSessionService();
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockUpdateProfileUsecase = MockUpdateProfileUsecase();

    when(() => mockSessionService.isLoggedIn()).thenReturn(true);
    when(() => mockSessionService.getCurrentUserId()).thenReturn('1');
    when(() => mockSessionService.getCurrentUserName()).thenReturn('Test User');
    when(
      () => mockSessionService.getCurrentUserEmail(),
    ).thenReturn('test@gmail.com');
    when(
      () => mockSessionService.getCurrentUserPhoneNumber(),
    ).thenReturn('9800000000');
    when(
      () => mockSessionService.getCurrentUserCountryCode(),
    ).thenReturn('+977');
    when(() => mockSessionService.getCurrentUserImageUrl()).thenReturn(null);
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        updateProfileUsecaseProvider.overrideWithValue(
          mockUpdateProfileUsecase,
        ),
        userSessionServiceProvider.overrideWithValue(mockSessionService),
      ],
      child: const MaterialApp(home: ProfileScreen()),
    );
  }

  group('ProfileScreen Logic Tests', () {
    testWidgets('should display user name and email from session service', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Handle the microtask in ViewModel build
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@gmail.com'), findsOneWidget);
    });

    testWidgets('should call logout usecase when logout button is tapped', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockLogoutUsecase(),
      ).thenAnswer((_) async => const Right(true));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pumpAndSettle();

      // Act
      final logoutBtn = find.text('Logout');
      await tester.ensureVisible(logoutBtn);
      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockLogoutUsecase()).called(1);
    });
  });
}
