import 'dart:convert';

import 'package:cleanarch_project/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const String CACHED_TRIVIA_KEY = "CACHED_NUMBER_TRIVIA";

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_TRIVIA_KEY);
    if (jsonString == null) {
      throw CacheException();
    }
    final jsonMap = json.decode(jsonString);
    return Future.value(NumberTriviaModel.fromJson(jsonMap));
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
        CACHED_TRIVIA_KEY, json.encode(triviaToCache.toJson()));
  }
}
