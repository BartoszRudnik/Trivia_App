import 'package:flutter/material.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:provider/src/provider.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({Key? key}) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  late TextEditingController textEditingController;
  late String inputStr;

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController();
  }

  void addConcrete() {
    textEditingController.clear();
    context.read<NumberTriviaBloc>().add(GetTriviaForConcreteNumber(numberString: inputStr));
  }

  void addRandom() {
    textEditingController.clear();
    context.read<NumberTriviaBloc>().add(GetTriviaForRandomNumber());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: textEditingController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            addConcrete();
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: const Text('Search'),
                onPressed: addConcrete,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey.shade500,
                ),
                child: const Text('Get random trivia'),
                onPressed: addRandom,
              ),
            ),
          ],
        )
      ],
    );
  }
}
