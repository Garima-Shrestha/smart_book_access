class HiveTableConstant {
  HiveTableConstant._();

  // Database name
  static const String dbName= 'novella_db';

  // Table name
  // User
  static const int authTypeId = 0;
  static const String authTable = 'user_table';

  // Category
  static const int categoryTypeId = 1;
  static const String categoryTable = 'category_table';

  // Book
  static const int bookTypeId = 2;
  static const String bookTable = 'book_table';

  // Rental History
  static const int rentalTypeId = 3;
  static const String rentalTable = 'rental_table';

  // Book Access
  static const int bookAccessTypeId = 4;
  static const String bookAccessTable = 'book_access_table';

  static const int bookmarkTypeId = 5;
  static const int quoteTypeId = 6;
  static const int selectionTypeId = 7;
  static const int lastPositionTypeId = 8;

  // My Library
  static const int myLibraryTypeId = 9;
  static const String myLibraryTable = 'my_library_table';
}