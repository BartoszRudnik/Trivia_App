import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../core/mock/mock_data_source.dart';

void main() {
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();

    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      networkInfo: mockNetworkInfo,
      numberTriviaLocalDataSource: mockLocalDataSource,
      numberTriviaRemoteDataSource: mockRemoteDataSource,
    );
  });

  group("getRandomNumberTrivia", () {
    const NumberTriviaModel numberTriviaModel = NumberTriviaModel(number: 123, text: "test trivia");
    const NumberTrivia numberTrivia = numberTriviaModel;

    test("should check if the device is online", () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => numberTriviaModel);

      await numberTriviaRepositoryImpl.getRandomNumberTrivia();

      verify(() => mockNetworkInfo.isConnected);
    });

    group("device is offline", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test("should return last locally cached data when the cached data is present", () async {
        when(() => mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => numberTriviaModel);

        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();

        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(numberTriviaModel)));
      });

      test("should return CacheFailure when there is no cached data present", () async {
        when(() => mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();

        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });

    group("device is online", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test("should return remote data when the call to remote data source is successful", () async {
        when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => numberTriviaModel);

        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();

        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(numberTriviaModel)));
      });

      test("should cache the data locally if the call to remote data source is succesfull", () async {
        when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => numberTriviaModel);

        await numberTriviaRepositoryImpl.getRandomNumberTrivia();

        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verify(() => mockLocalDataSource.cacheNumberTrivia(numberTriviaModel));
      });

      test("should return server failure when the call to remote data source is unsuccesfull", () async {
        when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());

        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();

        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyNoMoreInteractions(mockLocalDataSource);

        expect(result, equals(Left(ServerFailure())));
      });
    });
  });

  group("getConreteNumberTrivia", () {
    const int triviaNumber = 1;
    const NumberTriviaModel numberTriviaModel = NumberTriviaModel(number: triviaNumber, text: "test trivia");
    const NumberTrivia numberTrivia = numberTriviaModel;

    test("should check if the device is online", () {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(triviaNumber)).thenAnswer((_) async => numberTriviaModel);

      numberTriviaRepositoryImpl.getConcreteNumberTrivia(triviaNumber);

      verify(() => mockNetworkInfo.isConnected);
    });

    group("device is offline", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test("should return last locally cached data when the cached data is present", () async {
        when(() => mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => numberTriviaModel);

        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(triviaNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());

        expect(result, equals(const Right(numberTriviaModel)));
      });

      test("should return CacheFailure when there is no cached data present", () async {
        when(() => mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(triviaNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());

        expect(result, equals(Left(CacheFailure())));
      });
    });

    group("device is online", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test("should return remote data when the call to remote data source is successful", () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(triviaNumber)).thenAnswer((_) async => numberTriviaModel);

        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(triviaNumber);

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(triviaNumber));
        expect(result, equals(const Right(numberTrivia)));
      });

      test("should cache the data locally when the call to remote data source is successful", () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(triviaNumber)).thenAnswer((_) async => numberTriviaModel);

        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(triviaNumber);

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(triviaNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(numberTriviaModel));
      });

      test("should return server failure when the call to remote data source is unsuccessful", () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(triviaNumber)).thenThrow(ServerException());

        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(triviaNumber);

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(triviaNumber));
        verifyZeroInteractions(mockLocalDataSource);

        expect(result, equals(Left(ServerFailure())));
      });
    });
  });
}
