import 'dart:convert';

import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

const serverUrlConcrete = 'http://numbersapi.com/';
const serverUrlRandom = 'http://numbersapi.com/random';
const headers = {'Content-Type': 'application/json'};
const triviaNumber = 1;

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  http.Client client;

  NumberTriviaRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await client.get(Uri.parse(serverUrlConcrete + triviaNumber.toString()), headers: headers);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      return NumberTriviaModel.fromJson(responseBody);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await client.get(Uri.parse(serverUrlRandom), headers: headers);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return NumberTriviaModel.fromJson(responseBody);
    } else {
      throw ServerException();
    }
  }
}
