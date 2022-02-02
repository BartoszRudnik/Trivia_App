import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("string to unsigned int", () {
    test("should return unsigned int when the string represents an unsigned integer", () {
      const str = '123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, equals(const Right(123)));
    });

    test("should return failure when the string is a negative integer", () {
      const str = '-123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, equals(Left(InvalidInputFailure())));
    });

    test("should return failure when string is not integer", () {
      const str = 'abc';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
