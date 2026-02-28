import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/error/failures.dart';
import 'package:smart_book_access/core/services/connectivity/network_info.dart';
import 'package:smart_book_access/features/bookAccess/data/datasources/book_access_datasource.dart';
import 'package:smart_book_access/features/bookAccess/data/datasources/local/book_access_local_datasource.dart';
import 'package:smart_book_access/features/bookAccess/data/datasources/remote/book_access_remote_datasource.dart';
import 'package:smart_book_access/features/bookAccess/data/models/book_access_api_model.dart';
import 'package:smart_book_access/features/bookAccess/data/models/book_access_hive_model.dart';
import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
import 'package:smart_book_access/features/bookAccess/domain/repositories/book_access_repository.dart';

// Provider
final bookAccessRepositoryProvider = Provider<IBookAccessRepository>((ref) {
  final localDataSource = ref.read(bookAccessLocalDataSourceProvider);
  final remoteDataSource = ref.read(bookAccessRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return BookAccessRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class BookAccessRepository implements IBookAccessRepository {
  final IBookAccessLocalDataSource _localDataSource;
  final IBookAccessRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  BookAccessRepository({
    required IBookAccessLocalDataSource localDataSource,
    required IBookAccessRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, BookAccessEntity>> getBookAccess(String bookId) async {
    if (await _networkInfo.isConnected) {
      try {
        final localModel = await _localDataSource.getBookAccess(bookId);

        if (localModel != null) {
          final localPos = localModel.lastPosition;
          if (localPos != null) {
            try {
              await _remoteDataSource.updateLastPosition(
                bookId,
                LastPositionApiModel.fromEntity(
                  LastPositionEntity(
                    page: localPos.page,
                    offsetY: localPos.offsetY,
                    zoom: localPos.zoom,
                  ),
                ),
              );
            } catch (_) {}
          }

          final apiModel = await _remoteDataSource.getBookAccess(bookId);
          final serverEntity = apiModel.toEntity();

          final serverBookmarkKeys = serverEntity.bookmarks
              .map((b) => '${b.page}_${b.text}')
              .toSet();
          final offlineOnlyBookmarks = localModel.bookmarks
              .where((b) => !serverBookmarkKeys.contains('${b.page}_${b.text}'))
              .toList();

          final serverQuoteKeys = serverEntity.quotes
              .map((q) => '${q.page}_${q.text}')
              .toSet();
          final offlineOnlyQuotes = localModel.quotes
              .where((q) => !serverQuoteKeys.contains('${q.page}_${q.text}'))
              .toList();

          for (final b in offlineOnlyBookmarks) {
            try {
              await _remoteDataSource.addBookmark(
                bookId,
                BookmarkApiModel.fromEntity(BookmarkEntity(page: b.page, text: b.text)),
              );
            } catch (_) {}
          }

          for (final q in offlineOnlyQuotes) {
            try {
              await _remoteDataSource.addQuote(
                bookId,
                QuoteApiModel.fromEntity(QuoteEntity(page: q.page, text: q.text)),
              );
            } catch (_) {}
          }

          final BookAccessApiModel finalModel;
          if (offlineOnlyBookmarks.isNotEmpty || offlineOnlyQuotes.isNotEmpty) {
            finalModel = await _remoteDataSource.getBookAccess(bookId);
          } else {
            finalModel = apiModel;
          }

          await _localDataSource.saveBookAccess(
            BookAccessHiveModel.fromEntity(finalModel.toEntity()),
          );
          return Right(finalModel.toEntity());
        }

        final apiModel = await _remoteDataSource.getBookAccess(bookId);
        await _localDataSource.saveBookAccess(
          BookAccessHiveModel.fromEntity(apiModel.toEntity()),
        );
        return Right(apiModel.toEntity());

      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch book access',
          statusCode: e.response?.statusCode,
        ));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final localModel = await _localDataSource.getBookAccess(bookId);
        if (localModel != null) {
          return Right(localModel.toEntity());
        }
        return const Left(LocalDatabaseFailure(message: "No offline data found for this book"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<BookAccessEntity>>> getUserBooks() async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModels = await _remoteDataSource.getUserBooks();
        return Right(apiModels.map((m) => m.toEntity()).toList());
      } on DioException catch (e) {
        return Left(ApiFailure(message: e.message ?? "Error fetching rented books"));
      }
    } else {
      return const Left(ApiFailure(message: "Internet required to view rental list"));
    }
  }

  @override
  Future<Either<Failure, BookAccessEntity>> addBookmark(String bookId, BookmarkEntity bookmark) async {
    await _localDataSource.addBookmark(bookId, BookmarkHiveModel.fromEntity(bookmark));

    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _remoteDataSource.addBookmark(bookId, BookmarkApiModel.fromEntity(bookmark));
        return Right(apiModel.toEntity());
      } on DioException catch (e) {
        return Left(ApiFailure(message: "Saved locally, but failed to sync with server"));
      }
    }
    // If offline, we return the locally updated state (simulated)
    final local = await _localDataSource.getBookAccess(bookId);
    return Right(local!.toEntity());
  }

  @override
  Future<Either<Failure, BookAccessEntity>> removeBookmark(String bookId, int index) async {
    await _localDataSource.removeBookmark(bookId, index);

    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _remoteDataSource.removeBookmark(bookId, index);
        return Right(apiModel.toEntity());
      } on DioException catch (e) {
        return Left(ApiFailure(message: "Removed locally, but sync failed"));
      }
    }
    final local = await _localDataSource.getBookAccess(bookId);
    return Right(local!.toEntity());
  }

  @override
  Future<Either<Failure, BookAccessEntity>> addQuote(String bookId, QuoteEntity quote) async {
    await _localDataSource.addQuote(bookId, QuoteHiveModel.fromEntity(quote));

    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _remoteDataSource.addQuote(bookId, QuoteApiModel.fromEntity(quote));
        return Right(apiModel.toEntity());
      } on DioException catch (e) {
        return Left(ApiFailure(message: "Quote saved locally only"));
      }
    }
    final local = await _localDataSource.getBookAccess(bookId);
    return Right(local!.toEntity());
  }

  @override
  Future<Either<Failure, BookAccessEntity>> removeQuote(String bookId, int index) async {
    await _localDataSource.removeQuote(bookId, index);

    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _remoteDataSource.removeQuote(bookId, index);
        return Right(apiModel.toEntity());
      } on DioException catch (e) {
        return Left(ApiFailure(message: "Removed locally only"));
      }
    }
    final local = await _localDataSource.getBookAccess(bookId);
    return Right(local!.toEntity());
  }

  @override
  Future<Either<Failure, BookAccessEntity>> updateLastPosition(String bookId, LastPositionEntity lastPosition) async {
    await _localDataSource.updateLastPosition(bookId, LastPositionHiveModel.fromEntity(lastPosition));

    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _remoteDataSource.updateLastPosition(bookId, LastPositionApiModel.fromEntity(lastPosition));
        return Right(apiModel.toEntity());
      } catch (e) {
        final local = await _localDataSource.getBookAccess(bookId);
        return Right(local!.toEntity());
      }
    }
    final local = await _localDataSource.getBookAccess(bookId);
    return Right(local!.toEntity());
  }
}





// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:smart_book_access/core/error/failures.dart';
// import 'package:smart_book_access/core/services/connectivity/network_info.dart';
// import 'package:smart_book_access/features/bookAccess/data/datasources/book_access_datasource.dart';
// import 'package:smart_book_access/features/bookAccess/data/datasources/local/book_access_local_datasource.dart';
// import 'package:smart_book_access/features/bookAccess/data/datasources/remote/book_access_remote_datasource.dart';
// import 'package:smart_book_access/features/bookAccess/data/models/book_access_api_model.dart';
// import 'package:smart_book_access/features/bookAccess/data/models/book_access_hive_model.dart';
// import 'package:smart_book_access/features/bookAccess/domain/entities/book_access_entity.dart';
// import 'package:smart_book_access/features/bookAccess/domain/repositories/book_access_repository.dart';
//
// // Provider
// final bookAccessRepositoryProvider = Provider<IBookAccessRepository>((ref) {
//   final localDataSource = ref.read(bookAccessLocalDataSourceProvider);
//   final remoteDataSource = ref.read(bookAccessRemoteDataSourceProvider);
//   final networkInfo = ref.read(networkInfoProvider);
//   return BookAccessRepository(
//     localDataSource: localDataSource,
//     remoteDataSource: remoteDataSource,
//     networkInfo: networkInfo,
//   );
// });
//
// class BookAccessRepository implements IBookAccessRepository {
//   final IBookAccessLocalDataSource _localDataSource;
//   final IBookAccessRemoteDataSource _remoteDataSource;
//   final NetworkInfo _networkInfo;
//
//   BookAccessRepository({
//     required IBookAccessLocalDataSource localDataSource,
//     required IBookAccessRemoteDataSource remoteDataSource,
//     required NetworkInfo networkInfo,
//   })  : _localDataSource = localDataSource,
//         _remoteDataSource = remoteDataSource,
//         _networkInfo = networkInfo;
//
//   @override
//   Future<Either<Failure, BookAccessEntity>> getBookAccess(String bookId) async {
//     if (await _networkInfo.isConnected) {
//       try {
//         final apiModel = await _remoteDataSource.getBookAccess(bookId);
//         await _localDataSource.saveBookAccess(BookAccessHiveModel.fromEntity(apiModel.toEntity()));
//
//         return Right(apiModel.toEntity());
//       } on DioException catch (e) {
//         return Left(ApiFailure(
//           message: e.response?.data['message'] ?? 'Failed to fetch book access',
//           statusCode: e.response?.statusCode,
//         ));
//       } catch (e) {
//         return Left(ApiFailure(message: e.toString()));
//       }
//     } else {
//       try {
//         final localModel = await _localDataSource.getBookAccess(bookId);
//         if (localModel != null) {
//           return Right(localModel.toEntity());
//         }
//         return const Left(LocalDatabaseFailure(message: "No offline data found for this book"));
//       } catch (e) {
//         return Left(LocalDatabaseFailure(message: e.toString()));
//       }
//     }
//   }
//
//   @override
//   Future<Either<Failure, List<BookAccessEntity>>> getUserBooks() async {
//     if (await _networkInfo.isConnected) {
//       try {
//         final apiModels = await _remoteDataSource.getUserBooks();
//         return Right(apiModels.map((m) => m.toEntity()).toList());
//       } on DioException catch (e) {
//         return Left(ApiFailure(message: e.message ?? "Error fetching rented books"));
//       }
//     } else {
//       return const Left(ApiFailure(message: "Internet required to view rental list"));
//     }
//   }
//
//   @override
//   Future<Either<Failure, BookAccessEntity>> addBookmark(String bookId, BookmarkEntity bookmark) async {
//     await _localDataSource.addBookmark(bookId, BookmarkHiveModel.fromEntity(bookmark));
//
//     if (await _networkInfo.isConnected) {
//       try {
//         final apiModel = await _remoteDataSource.addBookmark(bookId, BookmarkApiModel.fromEntity(bookmark));
//         return Right(apiModel.toEntity());
//       } on DioException catch (e) {
//         return Left(ApiFailure(message: "Saved locally, but failed to sync with server"));
//       }
//     }
//     // If offline, we return the locally updated state (simulated)
//     final local = await _localDataSource.getBookAccess(bookId);
//     return Right(local!.toEntity());
//   }
//
//   @override
//   Future<Either<Failure, BookAccessEntity>> removeBookmark(String bookId, int index) async {
//     await _localDataSource.removeBookmark(bookId, index);
//
//     if (await _networkInfo.isConnected) {
//       try {
//         final apiModel = await _remoteDataSource.removeBookmark(bookId, index);
//         return Right(apiModel.toEntity());
//       } on DioException catch (e) {
//         return Left(ApiFailure(message: "Removed locally, but sync failed"));
//       }
//     }
//     final local = await _localDataSource.getBookAccess(bookId);
//     return Right(local!.toEntity());
//   }
//
//   @override
//   Future<Either<Failure, BookAccessEntity>> addQuote(String bookId, QuoteEntity quote) async {
//     await _localDataSource.addQuote(bookId, QuoteHiveModel.fromEntity(quote));
//
//     if (await _networkInfo.isConnected) {
//       try {
//         final apiModel = await _remoteDataSource.addQuote(bookId, QuoteApiModel.fromEntity(quote));
//         return Right(apiModel.toEntity());
//       } on DioException catch (e) {
//         return Left(ApiFailure(message: "Quote saved locally only"));
//       }
//     }
//     final local = await _localDataSource.getBookAccess(bookId);
//     return Right(local!.toEntity());
//   }
//
//   @override
//   Future<Either<Failure, BookAccessEntity>> removeQuote(String bookId, int index) async {
//     await _localDataSource.removeQuote(bookId, index);
//
//     if (await _networkInfo.isConnected) {
//       try {
//         final apiModel = await _remoteDataSource.removeQuote(bookId, index);
//         return Right(apiModel.toEntity());
//       } on DioException catch (e) {
//         return Left(ApiFailure(message: "Removed locally only"));
//       }
//     }
//     final local = await _localDataSource.getBookAccess(bookId);
//     return Right(local!.toEntity());
//   }
//
//   @override
//   Future<Either<Failure, BookAccessEntity>> updateLastPosition(String bookId, LastPositionEntity lastPosition) async {
//     await _localDataSource.updateLastPosition(bookId, LastPositionHiveModel.fromEntity(lastPosition));
//
//     if (await _networkInfo.isConnected) {
//       try {
//         final apiModel = await _remoteDataSource.updateLastPosition(bookId, LastPositionApiModel.fromEntity(lastPosition));
//         return Right(apiModel.toEntity());
//       } catch (e) {
//         final local = await _localDataSource.getBookAccess(bookId);
//         return Right(local!.toEntity());
//       }
//     }
//     final local = await _localDataSource.getBookAccess(bookId);
//     return Right(local!.toEntity());
//   }
// }
