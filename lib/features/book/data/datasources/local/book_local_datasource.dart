import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/services/hive/hive_service.dart';
import 'package:smart_book_access/features/book/data/datasources/book_datasource.dart';
import 'package:smart_book_access/features/book/data/models/book_hive_model.dart';

final bookLocalDataSourceProvider = Provider<BookLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return BookLocalDataSource(hiveService: hiveService);
});

class BookLocalDataSource implements IBookLocalDataSource {
  final HiveService _hiveService;

  BookLocalDataSource({
    required HiveService hiveService,
  }) : _hiveService = hiveService;

  @override
  Future<bool> addAllBooks(List<BookHiveModel> models) async {
    try {
      await _hiveService.addAllBooks(models);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<List<BookHiveModel>> getAllBooks() async {
    try {
      final books = await _hiveService.getAllBooks();
      return Future.value(books);
    } catch (e) {
      return Future.value([]);
    }
  }

  @override
  Future<BookHiveModel?> getBookById(String id) async {
    try {
      final book = await _hiveService.getBookById(id);
      return Future.value(book);
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<bool> clearBookBox() async {
    try {
      await _hiveService.clearBookBox();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}