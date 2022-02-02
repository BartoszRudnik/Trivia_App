import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final conversionResult = int.parse(str);

      if (conversionResult >= 0) {
        return Right(conversionResult);
      } else {
        return Left(InvalidInputFailure());
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
