import 'package:cleanarch_project/core/util/input_converter.dart';
import 'package:cleanarch_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanarch_project/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cleanarch_project/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:cleanarch_project/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:bloc_test/bloc_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test("Initial State Should be Empty", () {
    expect(bloc.state, NumberTriviaInitial());
  });

  group("getTriviaForConcreteNumber", () {
    const String tNumberString = "1";
    const int tNumberParsed = 1;
    const NumberTrivia tNumberTrivia =
        NumberTrivia(text: "test trivia", number: 1);

    test("should call inputConverter to validate and convert the string",
        () async {
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(const Right(tNumberParsed));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(
        () => mockInputConverter.stringToUnsignedInteger(any()),
      );
      verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test("should emit error state when input is invalid", () async {
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(Left(InvalidInputFailure()));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(
        () => mockInputConverter.stringToUnsignedInteger(any()),
      );

      expectLater(
          bloc.state, const NumberTriviaError(INVALID_INPUT_FAILURE_MSG));
    });

    blocTest(
        "emits NumberTriviaError when GetTriviaForConcreteNumber has InvalidInput",
        setUp: () {
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Left(InvalidInputFailure()));
        },
        wait: const Duration(seconds: 2),
        build: () => bloc,
        act: (b) => b.add(const GetTriviaForConcreteNumber(tNumberString)),
        expect: () => <NumberTriviaState>[
              const NumberTriviaError(INVALID_INPUT_FAILURE_MSG)
            ]);
  });
}
