import 'dart:convert';

import 'package:cleanarch_project/core/error/exceptions.dart';
import 'package:cleanarch_project/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:cleanarch_project/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl datasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group("getLastNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia_cached.json")));
    test(
        "should return number trivia from shared preferences when there is one in the cache",
        () async {
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture("trivia_cached.json"));
      final result = await datasource.getLastNumberTrivia();
      verify(() => mockSharedPreferences.getString(CACHED_TRIVIA_KEY));
      expect(result, tNumberTriviaModel);
    });

    test("should thown cacheException when there is no cached value", () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      final call = datasource.getLastNumberTrivia;
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group("cacheNumberTrivia", () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: "test trivia");
    test("should call SharedPreferences to cache the data", () async {
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) => Future.value(true));
      await datasource.cacheNumberTrivia(tNumberTriviaModel);
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(() => mockSharedPreferences.setString(
          CACHED_TRIVIA_KEY, expectedJsonString));
    });
  });
}
