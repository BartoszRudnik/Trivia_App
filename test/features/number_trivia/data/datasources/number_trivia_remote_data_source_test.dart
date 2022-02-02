import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../core/mock/mock_http_client.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  late NumberTriviaRemoteDataSourceImpl remoteDataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();

    remoteDataSource = NumberTriviaRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  void setUpMockHttpClientSuccess200(String url) {
    when(() => mockHttpClient.get(Uri.parse(url), headers: headers)).thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));
  }

  void setUpMockHttpClientFailure404(String url) {
    when(() => mockHttpClient.get(Uri.parse(url), headers: headers)).thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  group("getRandomNumberTrivia", () {
    final numberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test("should perform a GET request on a URL with random enpoint with application/json header", () {
      setUpMockHttpClientSuccess200(serverUrlRandom);

      remoteDataSource.getRandomNumberTrivia();

      verify(() => mockHttpClient.get(Uri.parse(serverUrlRandom), headers: headers));
    });

    test("should return NumberTrivia when the response code is 200", () async {
      setUpMockHttpClientSuccess200(serverUrlRandom);

      final result = await remoteDataSource.getRandomNumberTrivia();

      expect(result, equals(numberTriviaModel));
    });

    test("should throw a ServerException when the response code is 404 or other", () {
      setUpMockHttpClientFailure404(serverUrlRandom);

      final call = remoteDataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("getConcreteNumberTrivia", () {
    final numberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test("should perform a GET request on a URL with number being the endpint and with application/json header", () async {
      setUpMockHttpClientSuccess200(serverUrlConcrete + triviaNumber.toString());

      remoteDataSource.getConcreteNumberTrivia(triviaNumber);

      verify(() => mockHttpClient.get(Uri.parse(serverUrlConcrete + triviaNumber.toString()), headers: headers));
    });

    test("should return NumberTrivia when the response code is 200", () async {
      setUpMockHttpClientSuccess200(serverUrlConcrete + triviaNumber.toString());

      final result = await remoteDataSource.getConcreteNumberTrivia(triviaNumber);

      expect(result, equals(numberTriviaModel));
    });

    test("should throw ServerException when the response code is 404 or other", () async {
      setUpMockHttpClientFailure404(serverUrlConcrete + triviaNumber.toString());

      final call = remoteDataSource.getConcreteNumberTrivia;

      expect(() => call(triviaNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
