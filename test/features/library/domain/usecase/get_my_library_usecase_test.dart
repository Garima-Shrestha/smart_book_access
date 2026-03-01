import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/features/library/domain/entities/my_library_entity.dart';
import 'package:smart_book_access/features/library/domain/repositories/my_library_repository.dart';
import 'package:smart_book_access/features/library/domain/usecase/get_my_library_usecase.dart';

class MockMyLibraryRepository extends Mock implements IMyLibraryRepository {}

class MockFailure extends Failure {
  const MockFailure() : super('Failed to fetch library');
}

void main() {
  late GetMyLibraryUsecase usecase;
  late MockMyLibraryRepository mockRepository;

  setUp(() {
    mockRepository = MockMyLibraryRepository();
    usecase = GetMyLibraryUsecase(myLibraryRepository: mockRepository);
  });

  const tLibrary = [
    MyLibraryEntity(
      accessId: 'access_1',
      bookId: 'book_1',
      title: 'Test Book',
      author: 'Test Author',
      pages: 100,
      progressPercent: 50,
      timeLeftLabel: '3 days left',
      isExpired: false,
      isInactive: false,
      canReRent: false,
    ),
  ];

  const tParams = GetMyLibraryUsecaseParams(page: 1, size: 10);

  group('GetMyLibraryUsecase', () {
    test(
      'should return Right(List<MyLibraryEntity>) when fetch is successful',
      () async {
        when(
          () => mockRepository.getMyLibrary(
            page: any(named: 'page'),
            size: any(named: 'size'),
          ),
        ).thenAnswer((_) async => const Right(tLibrary));

        final result = await usecase(tParams);

        expect(result, const Right(tLibrary));
        verify(
          () => mockRepository.getMyLibrary(
            page: tParams.page,
            size: tParams.size,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return Left(Failure) when fetch fails', () async {
      const tFailure = MockFailure();
      when(
        () => mockRepository.getMyLibrary(
          page: any(named: 'page'),
          size: any(named: 'size'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(
        () => mockRepository.getMyLibrary(
          page: any(named: 'page'),
          size: any(named: 'size'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
