import 'dart:convert';

import 'package:cleanarch_project/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final endpointUrlString = "http://numbersapi.com/$number";
    return _getTriviaFromUrl(endpointUrlString);
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    const endpointUrlString = "http://numbersapi.com/random";
    return _getTriviaFromUrl(endpointUrlString);
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String urlString) async {
    final url = Uri.parse(urlString);
    final headers = {"Content-Type": "application/json"};
    final response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }

    throw ServerException();
  }
}
