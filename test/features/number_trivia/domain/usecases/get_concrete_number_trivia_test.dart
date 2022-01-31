import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import '../../../../core/mock/mock_number_trivia_repository.dart';

void main() {
  late GetConcreteNumberTrivia getConreteNumberTrivia;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getConreteNumberTrivia = GetConcreteNumberTrivia(numberTriviaRepository: mockNumberTriviaRepository);
  });

  const triviaNumber = 1;
  const numberTrivia = NumberTrivia(text: "test", number: 1);

  test("should get trivia for the number from the repository", () async {
    when(() => mockNumberTriviaRepository.getConreteNumberTrivia(triviaNumber)).thenAnswer((_) async => const Right(numberTrivia));

    final result = await getConreteNumberTrivia(params: const Params(number: triviaNumber));

    expect(result, equals(const Right(numberTrivia)));

    verify(() => mockNumberTriviaRepository.getConreteNumberTrivia(triviaNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
