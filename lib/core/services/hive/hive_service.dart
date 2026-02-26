import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/core/constants/hive_table_constant.dart';
import 'package:smart_book_access/features/auth/data/models/auth_hive_model.dart';
import 'package:smart_book_access/features/book/data/models/book_hive_model.dart';
import 'package:smart_book_access/features/bookAccess/data/models/book_access_hive_model.dart';
import 'package:smart_book_access/features/category/data/models/category_hive_model.dart';
import 'package:smart_book_access/features/history/data/models/history_hive_model.dart';
import 'package:smart_book_access/features/library/data/models/my_library_hive_model.dart';


final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});


class HiveService {
  // init
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapter();
    await openBoxes();
  }

  // Register Adapter
  void _registerAdapter() {
    if(!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)){
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.categoryTypeId)) {
      Hive.registerAdapter(CategoryHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.bookTypeId)) {
      Hive.registerAdapter(BookHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.bookAccessTypeId)) {
      Hive.registerAdapter(BookAccessHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.bookmarkTypeId)) {
      Hive.registerAdapter(BookmarkHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.quoteTypeId)) {
      Hive.registerAdapter(QuoteHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.selectionTypeId)) {
      Hive.registerAdapter(SelectionHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.lastPositionTypeId)) {
      Hive.registerAdapter(LastPositionHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.myLibraryTypeId)) {
      Hive.registerAdapter(MyLibraryHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.rentalTypeId)) {
      Hive.registerAdapter(HistoryHiveModelAdapter());
    }
  }

  // Open Boxes
  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryTable);
    await Hive.openBox<BookHiveModel>(HiveTableConstant.bookTable);
    await Hive.openBox<BookAccessHiveModel>(HiveTableConstant.bookAccessTable);
    await Hive.openBox<MyLibraryHiveModel>(HiveTableConstant.myLibraryTable);
    await Hive.openBox<HistoryHiveModel>(HiveTableConstant.rentalTable);
  }

  // Close Boxes
  Future<void> close() async {
    await Hive.close();
  }


  //-------------------Auth Queries-----------------
  Box<AuthHiveModel> get _authBox => 
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  // Register
  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }

  // Login
  Future<AuthHiveModel?> login(String email, String password) async {
    final users = _authBox.values.where(
        (user) => user.email == email && user.password == password,
    );
    if(users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // Logout
  Future<void> logoutUser() async {}

  // get current user
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  // is email exists
  bool isEmailExists(String email) {
    final users =_authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }

  // Update User Profile
  Future<void> updateUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
  }


  // -------------------Category Queries-----------------
  Box<CategoryHiveModel> get _categoryBox =>
      Hive.box<CategoryHiveModel>(HiveTableConstant.categoryTable);

  Future<void> addAllCategories(List<CategoryHiveModel> models) async {
    for (var model in models) {
      await _categoryBox.put(model.categoryId, model);
    }
  }

  List<CategoryHiveModel> getAllCategories() {
    return _categoryBox.values.toList();
  }


  // -------------------Book Queries-----------------
  Box<BookHiveModel> get _bookBox =>
      Hive.box<BookHiveModel>(HiveTableConstant.bookTable);

  // Add all books to cache
  Future<void> addAllBooks(List<BookHiveModel> models) async {
    for (var model in models) {
      await _bookBox.put(model.bookId, model);
    }
  }

  // Get all cached books
  List<BookHiveModel> getAllBooks() {
    return _bookBox.values.toList();
  }

  // Get a single book by ID
  BookHiveModel? getBookById(String bookId) {
    return _bookBox.get(bookId);
  }

  // Delete all cached books
  Future<void> clearBookBox() async {
    await _bookBox.clear();
  }


  // -------------------Book Access Queries-----------------
  Box<BookAccessHiveModel> get _bookAccessBox =>
      Hive.box<BookAccessHiveModel>(HiveTableConstant.bookAccessTable);

  Future<void> saveBookAccess(BookAccessHiveModel model) async {
    await _bookAccessBox.put(model.bookId, model);
  }

  BookAccessHiveModel? getBookAccess(String bookId) {
    return _bookAccessBox.get(bookId);
  }

  Future<void> clearBookAccessBox() async {
    await _bookAccessBox.clear();
  }


  // -------------------My Library Queries-----------------
  Box<MyLibraryHiveModel> get _myLibraryBox =>
      Hive.box<MyLibraryHiveModel>(HiveTableConstant.myLibraryTable);

  // Cache all my library items
    Future<void> cacheMyLibrary(List<MyLibraryHiveModel> models) async {
      await _myLibraryBox.clear();
      for (final model in models) {
        await _myLibraryBox.put(model.accessId, model);
      }
    }

  // Get all cached my library items
    List<MyLibraryHiveModel> getCachedMyLibrary() {
      return _myLibraryBox.values.toList();
    }

  // Clear cache
    Future<void> clearMyLibraryCache() async {
      await _myLibraryBox.clear();
    }



  // -------------------History Queries-----------------
  Box<HistoryHiveModel> get _historyBox =>
      Hive.box<HistoryHiveModel>(HiveTableConstant.rentalTable);

  // Cache history items
  Future<void> cacheHistory(List<HistoryHiveModel> models) async {
    await _historyBox.clear();
    for (final model in models) {
      await _historyBox.put(model.accessId, model);
    }
  }

  // Get cached history items
  List<HistoryHiveModel> getCachedHistory() {
    return _historyBox.values.toList();
  }

  // Clear history cache
  Future<void> clearHistoryCache() async {
    await _historyBox.clear();
  }
}