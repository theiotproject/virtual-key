import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

// file which has the getNumberTrivia function
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:virtual_key/services/remote_service.dart';

void main() {
  group('getNumberTrivia', () {
    test('returns number trivia string when http response is successful',
        () async {
      // Mock the API call to return a json response with http status 200 Ok //
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        final response = {
          "text":
              "22834 is the feet above sea level of the highest mountain in the Western Hemisphere, Mount Aconcagua in Argentina.",
          "number": 22834,
          "found": true,
          "type": "trivia"
        };
        return Response(jsonEncode(response), 200);
      });
      // Check whether getNumberTrivia function returns
      // number trivia which will be a String
      expect(await RemoteService().getNumberTriviaa(mockHTTPClient),
          isA<String>());
    });

    test('return error message when http response is unsuccessful', () async {
      // Mock the API call to return an
      // empty json response with http status 404
      final mockHTTPClient = MockClient((request) async {
        final response = {};
        return Response(jsonEncode(response), 404);
      });
      expect(await RemoteService().getNumberTriviaa(mockHTTPClient),
          'Failed to fetch number trivia');
    });
  });
}
