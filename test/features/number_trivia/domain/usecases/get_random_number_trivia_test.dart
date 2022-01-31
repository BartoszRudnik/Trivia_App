import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import '../../../../core/mock/mock_number_trivia_repository.dart';

void main() {
  late GetRandomNumberTrivia getRandomNumberTrivia;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getRandomNumberTrivia = GetRandomNumberTrivia(numberTriviaRepository: mockNumberTriviaRepository);
  });

  const NumberTrivia numberTrivia = NumberTrivia(text: "test", number: 1);

  test("should get trivia from the repository", () async {
    when(() => mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer((_) async => const Right(numberTrivia));

    final result = await getRandomNumberTrivia(params: NoParams());

    expect(result, const Right(numberTrivia));

    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
