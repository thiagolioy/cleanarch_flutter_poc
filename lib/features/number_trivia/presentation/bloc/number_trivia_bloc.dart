import 'package:bloc/bloc.dart';
import 'package:cleanarch_project/core/util/input_converter.dart';
import 'package:cleanarch_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanarch_project/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cleanarch_project/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MSG = "Server Failure";
const String CACHE_FAILURE_MSG = "Cache Failure";
const String INVALID_INPUT_FAILURE_MSG = "Invalid Input";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(NumberTriviaInitial()) {
    on<GetTriviaForRandomNumber>((event, emit) {});

    on<GetTriviaForConcreteNumber>((event, emit) {
      final input = inputConverter.stringToUnsignedInteger(event.numberString);
      input.fold((failure) {
        emit(const NumberTriviaError(INVALID_INPUT_FAILURE_MSG));
      }, (number) {
        throw UnimplementedError();
      });
    });
  }
}
