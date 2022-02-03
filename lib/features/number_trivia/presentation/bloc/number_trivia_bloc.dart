import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = "Server Failure";
const String cacheFailureMessage = "Cache Failure";
const String invalidInputFailureMessage = "Invalid input - The number must be a positive integer or zero.";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaState get initialState => Empty();

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

      await inputEither.fold((failure) {
        emit(const ErrorState(errorMessage: invalidInputFailureMessage));
      }, (integer) async {
        emit(Loading());

        final failureOrTrivia = await getConcreteNumberTrivia(params: Params(number: integer));

        await failureOrTrivia!.fold(
          (failure) async {
            emit(
              ErrorState(errorMessage: _mapFailureToMessage(failure)),
            );
          },
          (trivia) async {
            emit(Loaded(numberTrivia: trivia));
          },
        );
      });
    });
    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());

      final failureOrTrivia = await getRandomNumberTrivia(params: NoParams());

      failureOrTrivia!.fold(
        (failure) => emit(
          ErrorState(errorMessage: _mapFailureToMessage(failure)),
        ),
        (numberTrivia) => emit(Loaded(numberTrivia: numberTrivia)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
