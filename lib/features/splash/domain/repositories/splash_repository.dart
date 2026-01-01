import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract interface class ISplashRepository {
  // Returns true if the user is already logged in
  Future<Either<Failure, bool>> isUserLoggedIn();
}