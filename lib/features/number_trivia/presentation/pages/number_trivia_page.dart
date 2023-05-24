import 'package:cleanarch_project/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cleanarch_project/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import "package:flutter/material.dart";
import '../widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Trivia"),
      ),
      body: SingleChildScrollView(child: _buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              ..._buildDisplayElements(context),
              const TriviaControls()
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDisplayElements(BuildContext context) {
    return <Widget>[
      const SizedBox(
        height: 10.0,
      ),
      BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
          builder: (context, state) {
        if (state is NumberTriviaInitial) {
          return const MessageDisplay(message: "start searching!");
        } else if (state is NumberTriviaLoadInProgress) {
          return const LoadingWidget();
        } else if (state is NumberTriviaError) {
          return MessageDisplay(message: state.message);
        } else if (state is NumberTriviaLoaded) {
          return TriviaDisplay(trivia: state.trivia);
        }
        return const Placeholder();
      }),
      const SizedBox(
        height: 10.0,
      )
    ];
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputString = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Input a number"),
          onChanged: (value) {
            inputString = value;
          },
          onSubmitted: (_) => dispatchConcrete(),
        ),
        SizedBox(
          height: 10.0,
        ),
        _buildActionsRow(context)
      ],
    );
  }

  Widget _buildActionsRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            onPressed: () => dispatchConcrete(),
            child: const Text("Search"),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () => dispatchRandom(),
            child: const Text("Get Random Trivia"),
          ),
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputString));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
