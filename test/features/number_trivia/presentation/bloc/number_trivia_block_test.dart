import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
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

  group("GetTriviaForRandomNumber", () {
    const NumberTrivia numberTrivia = NumberTrivia(text: "test trivia", number: 1);

    test("should get data from the random use case", () async {
      when(() => mockGetRandomNumberTrivia(params: NoParams())).thenAnswer((invocation) async => const Right(numberTrivia));

      numberTriviaBloc.add(GetTriviaForRandomNumber());
      await untilCalled(() => mockGetRandomNumberTrivia(params: NoParams()));

      verify(() => mockGetRandomNumberTrivia(params: NoParams()));
    });

    test("should emit [Loading, Loaded] when data is gotten successfully", () async {
      when(() => mockGetRandomNumberTrivia(params: NoParams())).thenAnswer((invocation) async => const Right(numberTrivia));

      final expected = [Loading(), const Loaded(numberTrivia: numberTrivia)];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });

    test("should emit [Loading, Error] when getting data fails", () async {
      when(() => mockGetRandomNumberTrivia(params: NoParams())).thenAnswer((invocation) async => Left(ServerFailure()));

      final expected = [Loading(), const ErrorState(errorMessage: serverFailureMessage)];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });

    test("should emit [Loading, Error] with a proper message for the error when getting data fails", () async {
      when(() => mockGetRandomNumberTrivia(params: NoParams())).thenAnswer((invocation) async => Left(CacheFailure()));

      final expected = [Loading(), const ErrorState(errorMessage: serverFailureMessage)];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });
  });

  group("GetTriviaForConcreteNumber", () {
    const numberString = "1";
    const invalidString = "-123";
    const number = 1;
    const NumberTrivia numberTrivia = NumberTrivia(text: "test trivia", number: 1);

    test("should call the InputConverter to validate and convert the string to an unsigned integer", () async {
      when(() => mockInputConverter.stringToUnsignedInteger(numberString)).thenReturn(const Right(number));
      when(() => mockGetConcreteNumberTrivia(params: const Params(number: number))).thenAnswer((invocation) async => const Right(numberTrivia));

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

    test("should get data from the concrete use case", () async {
      when(() => mockInputConverter.stringToUnsignedInteger(numberString)).thenReturn(const Right(number));
      when(() => mockGetConcreteNumberTrivia(params: const Params(number: number))).thenAnswer((invocation) async => const Right(numberTrivia));

      numberTriviaBloc.add(const GetTriviaForConcreteNumber(numberString: numberString));
      await untilCalled(() => mockInputConverter.stringToUnsignedInteger(numberString));

      verify(() => mockGetConcreteNumberTrivia(params: const Params(number: number)));
    });

    test("should emit [Loading, Loaded] when data is gotten successfully", () async {
      when(() => mockInputConverter.stringToUnsignedInteger(numberString)).thenReturn(const Right(number));
      when(() => mockGetConcreteNumberTrivia(params: const Params(number: number))).thenAnswer((invocation) async => const Right(numberTrivia));

      final expected = [Loading(), const Loaded(numberTrivia: numberTrivia)];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

      numberTriviaBloc.add(const GetTriviaForConcreteNumber(numberString: numberString));
    });

    test("should emit [Loading, Error] when getting data fails", () async {
      when(() => mockInputConverter.stringToUnsignedInteger(numberString)).thenReturn(const Right(number));
      when(() => mockGetConcreteNumberTrivia(params: const Params(number: number))).thenAnswer((invocation) async => Left(ServerFailure()));

      final expected = [Loading(), const ErrorState(errorMessage: serverFailureMessage)];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

      numberTriviaBloc.add(const GetTriviaForConcreteNumber(numberString: numberString));
    });

    test("should emit [Loading, Error] with a proper message for the error when getting data fails", () async {
      when(() => mockInputConverter.stringToUnsignedInteger(numberString)).thenReturn(const Right(number));
      when(() => mockGetConcreteNumberTrivia(params: const Params(number: number))).thenAnswer((invocation) async => Left(CacheFailure()));

      final expected = [Loading(), const ErrorState(errorMessage: serverFailureMessage)];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

      numberTriviaBloc.add(const GetTriviaForConcreteNumber(numberString: numberString));
    });
  });
}
