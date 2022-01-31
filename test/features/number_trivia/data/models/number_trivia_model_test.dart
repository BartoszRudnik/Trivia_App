import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late NumberTriviaModel numberTriviaModel;

  setUp(() {
    numberTriviaModel = const NumberTriviaModel(number: 1, text: "Test Text");
  });

  test("should be a subclass of NumberTrivia entity", () async {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  group("to json", () {
    test("should return a JSON map containing the proper data", () async {
      final result = numberTriviaModel.toJson();

      final expectedResult = {
        "number": 1,
        "text": "Test Text",
      };

      expect(result, expectedResult);
    });
  });

  group("from json", () {
    test("should return a valid model when the JSON number is an integer", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture("trivia.json"));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, numberTriviaModel);
    });

    test("should return a valid model when the JSON number is a double", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture("trivia_double.json"));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, numberTriviaModel);
    });
  });
}
