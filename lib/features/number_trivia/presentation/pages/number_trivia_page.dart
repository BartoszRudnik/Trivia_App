import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:number_trivia/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Trivia"),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => sl<NumberTriviaBloc>(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is Empty) {
                        return const MessageDisplay(message: 'Start searching');
                      } else if (state is Loading) {
                        return const LoadingWidget();
                      } else if (state is Loaded) {
                        return TriviaDisplay(numberTrivia: state.numberTrivia);
                      } else if (state is ErrorState) {
                        return MessageDisplay(message: state.errorMessage);
                      }
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: const Placeholder(),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const TriviaControls(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
