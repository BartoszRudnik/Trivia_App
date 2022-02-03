import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia extends Usecase<NumberTrivia, Params> {
  final NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTrivia({
    required this.numberTriviaRepository,
  });

  @override
  Future<Either<Failure, NumberTrivia>?> call({required Params params}) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({
    required this.number,
  });

  @override
  List<Object?> get props => [number];
}
