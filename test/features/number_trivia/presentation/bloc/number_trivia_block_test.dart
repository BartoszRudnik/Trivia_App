import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import '../../../../core/mock/mock_get_concrete_number_trivia.dart';
import '../../../../core/mock/mock_get_random_number_trivia.dart';
import '../../../../core/mock/mock_input_converter.dart';

void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockInputConverter mockInputConverter;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();

    numberTriviaBloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test("initial state should be empty", () {
    expect(numberTriviaBloc.initialState, equals(Empty()));
  });

  group("GetTriviaForConcreteNumber", () {
    const numberString = "1";
    const invalidString = "-123";
    const number = 1;
    const NumberTrivia numberTrivia = NumberTrivia(text: "test trivia", number: 1);

    test("should call the InputConverter to validate and convert the string to an unsigned integer", () async {
      when(() => mockInputConverter.stringToUnsignedInteger(numberString)).thenReturn(const Right(number));

      numberTriviaBloc.add(const GetTriviaForConcreteNumber(numberString: numberString));
      await untilCalled(() => mockInputConverter.stringToUnsignedInteger(numberString));

      verify(() => mockInputConverter.stringToUnsignedInteger(numberString));
    });

    test("should emit [Error] when the input is invalid", () async {
      when(() => mockInputConverter.stringToUnsignedInteger(invalidString)).thenReturn(Left(InvalidInputFailure()));

      final expected = [
        const ErrorState(errorMessage: invalidInputFailureMessage),
      ];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

      numberTriviaBloc.add(const GetTriviaForConcreteNumber(numberString: invalidString));
    });
  });
}
