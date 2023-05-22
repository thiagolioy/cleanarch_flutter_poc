import 'dart:convert';
import 'dart:io';

import 'package:cleanarch_project/core/error/exceptions.dart';
import 'package:cleanarch_project/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:cleanarch_project/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:cleanarch_project/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl datasource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group("getConcreteNumberTrivia", () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));
    final url = Uri.parse("http://numbersapi.com/$tNumber");
    final headers = {"Content-Type": "application/json"};

    test("should perform a GET request on a URL with number being the endpoint",
        () async {
      when(() => mockHttpClient.get(url, headers: headers))
          .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));

      datasource.getConcreteNumberTrivia(tNumber);

      verify(() => mockHttpClient.get(url, headers: headers));
    });

    test("should return number trivia when the response code is 200", () async {
      when(() => mockHttpClient.get(url, headers: headers))
          .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));

      final result = await datasource.getConcreteNumberTrivia(tNumber);

      expect(result, tNumberTriviaModel);
    });

    test("should throw server exception when the response code is a error code",
        () async {
      when(() => mockHttpClient.get(url, headers: headers))
          .thenAnswer((_) async => http.Response("somthing went wrong", 404));

      final call = datasource.getConcreteNumberTrivia;

      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));
    final url = Uri.parse("http://numbersapi.com/random");
    final headers = {"Content-Type": "application/json"};

    test("should return number a random trivia when the response code is 200",
        () async {
      when(() => mockHttpClient.get(url, headers: headers))
          .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));

      final result = await datasource.getRandomNumberTrivia();

      expect(result, tNumberTriviaModel);
    });

    test("should throw server exception when the response code is a error code",
        () async {
      when(() => mockHttpClient.get(url, headers: headers))
          .thenAnswer((_) async => http.Response("somthing went wrong", 404));

      final call = datasource.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
