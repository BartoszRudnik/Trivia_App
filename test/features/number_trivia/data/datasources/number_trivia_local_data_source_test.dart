import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../core/mock/mock_shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  late NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();

    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group("cacheNumberTrivia", () {
    const numberTriviaModelToCache = NumberTriviaModel(number: 1, text: "test trivia");

    test("should call SharedPreferences to cache the data", () {
      final expectedJsonString = json.encode(numberTriviaModelToCache.toJson());
      when(() => mockSharedPreferences.setString(cachedNumberTrivia, expectedJsonString)).thenAnswer((_) async => true);

      numberTriviaLocalDataSourceImpl.cacheNumberTrivia(numberTriviaModelToCache);

      verify(() => mockSharedPreferences.setString(cachedNumberTrivia, expectedJsonString));
    });
  });

  group("getLastNumberTrivia", () {
    final numberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test("should throw a CacheException when there is not a cached value", () {
      when(() => mockSharedPreferences.getString(cachedNumberTrivia)).thenReturn(null);

      final call = numberTriviaLocalDataSourceImpl.getLastNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });

    test("should return NumberTrivia from SharedPreferences when there is one in the cache", () async {
      when(() => mockSharedPreferences.getString(cachedNumberTrivia)).thenReturn(fixture("trivia_cached.json"));

      final result = await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();

      verify(() => mockSharedPreferences.getString(cachedNumberTrivia));
      expect(result, equals(numberTriviaModel));
    });
  });
}
