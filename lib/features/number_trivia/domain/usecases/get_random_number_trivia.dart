import 'package:dartz/dartz.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository numberTriviaRepository;

  GetRandomNumberTrivia({
    required this.numberTriviaRepository,
  });

  @override
  Future<Either<Failure, NumberTrivia>?> call({required NoParams params}) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}
