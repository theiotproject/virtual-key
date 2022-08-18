import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:virtual_key/models/gate.dart';
import 'package:virtual_key/models/team.dart';
import 'package:virtual_key/models/user.dart';
import 'package:virtual_key/models/virtual_key.dart';
import 'package:virtual_key/services/remote_service.dart';


enum ConnectivityCase { CASE_ERROR, CASE_SUCCESS }

class MockConnectivity implements Connectivity {
  var connectivityCase = ConnectivityCase.CASE_SUCCESS;

  late Stream<ConnectivityResult> _onConnectivityChanged;

  @override
  Future<ConnectivityResult> checkConnectivity() {
    if (connectivityCase == ConnectivityCase.CASE_SUCCESS) {
      return Future.value(ConnectivityResult.wifi);
    } else {
      throw Error();
    }
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    if (_onConnectivityChanged == null) {
      _onConnectivityChanged = Stream<ConnectivityResult>.fromFutures([
        Future.value(ConnectivityResult.wifi),
        Future.value(ConnectivityResult.none),
        Future.value(ConnectivityResult.mobile)
      ]).asyncMap((data) async {
        await Future.delayed(const Duration(seconds: 1));
        return data;
      });
    }
    return _onConnectivityChanged;
  }

  @override
  Future<String> getWifiBSSID() {
    return Future.value("");
  }

  @override
  Future<String> getWifiIP() {
    return Future.value("");
  }

  @override
  Future<String> getWifiName() {
    return Future.value("");
  }
}

void main() {
  group('getUser', () {
    test('returns User object when http response is successful', () async {
      // Mock the API call to return a json response with http status 200
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call
        final response = {
          'id': 1,
          'name': 'test',
          'email': 'test@test.com',
          'email_verified_at': '2022-01-01T01:01:01.000Z',
          'two_factor_confirmed_at': null,
          'current_team_id': 1,
          'profile_photo_path': null,
          'created_at': '2022-01-01T01:01:01.000Z',
          'updated_at': '2022-01-01T01:01:01.000Z',
          'profile_photo_url': ''
        };
        return Response(jsonEncode(response), 200);
      });
      // Check whether getUser function returns User object
      expect(await RemoteService().getUser(mockHTTPClient), isA<User>());
    });

    test('returns null when http response is unsuccessful', () async {
      // Mock the API call to return an empty json response with http status 404
      final mockHTTPClient = MockClient((request) async {
        final response = {};
        return Response(jsonEncode(response), 404);
      });
      // Check whether getUser function returns null
      expect(await RemoteService().getUser(mockHTTPClient), null);
    });
  });

  group('getTeams', () {
    test('returns list of Team objects when http response is successful',
        () async {
      // Mock the API call to return a json response with http status 200
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call
        final response = [
          {
            'id': 1,
            'user_id': 1,
            'name': 'test team',
            'personal_team': true,
            'created_at': '2022-01-01T01:01:01.000Z',
            'updated_at': '2022-01-01T01:01:01.000Z',
            "team_code": '20TEST10QW',
          }
        ];
        return Response(jsonEncode(response), 200);
      });
      // Check whether getTeams function returns list of User objects
      expect(
          await RemoteService().getTeams(mockHTTPClient, 1), isA<List<Team>>());
    });

    test('returns null when http response is unsuccessful', () async {
      // Mock the API call to return an empty json response with http status 404
      final mockHTTPClient = MockClient((request) async {
        final response = {};
        return Response(jsonEncode(response), 404);
      });
      // Check whether getTeams function returns null
      expect(await RemoteService().getTeams(mockHTTPClient, 1), null);
    });
  });

  group('getKeys', () {
    test('returns list of VirtualKey objects when http response is successful',
        () async {
      // Mock the API call to return a json response with http status 200
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call
        final response = [
          {
            'id': 1,
            'label': 'test',
            'user_id': 1,
            'valid_days': 'MFS',
            'created_at': '2022-01-01T01:01:01.000Z',
            'updated_at': '2022-01-01T01:01:01.000Z',
          }
        ];
        return Response(jsonEncode(response), 200);
      });
      // Check whether getKeys function returns list of VirtualKey objects
      expect(await RemoteService().getKeys(mockHTTPClient, 1),
          isA<List<VirtualKey>>());
    });

    test('returns null when http response is unsuccessful', () async {
      // Mock the API call to return an empty json response with http status 404
      final mockHTTPClient = MockClient((request) async {
        final response = {};
        return Response(jsonEncode(response), 404);
      });
      // Check whether getKeys function returns null
      expect(await RemoteService().getKeys(mockHTTPClient, 1), null);
    });
  });

  group('getKeyGates', () {
    test('returns list of Gate objects when http response is successful',
        () async {
      // Mock the API call to return a json response with http status 200
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call
        final response = [
          {
            'id': 1,
            'name': 'test lock',
            'serial_number': '1A2B3C4D5E',
            'magic_code': '12345678-246e-414a-test-12abc6789012',
            'team_id': 1,
            'created_at': '2022-01-01T01:01:01.000Z',
            'updated_at': '2022-01-01T01:01:01.000Z'
          }
        ];
        return Response(jsonEncode(response), 200);
      });
      // Check whether getKeyGates function returns list of Gate objects
      expect(await RemoteService().getKeyGates(mockHTTPClient, 1),
          isA<List<Gate>>());
    });

    test('returns null when http response is unsuccessful', () async {
      // Mock the API call to return an empty json response with http status 404
      final mockHTTPClient = MockClient((request) async {
        final response = {};
        return Response(jsonEncode(response), 404);
      });
      // Check whether getKeyGates function returns null
      expect(await RemoteService().getKeyGates(mockHTTPClient, 1), null);
    });
  });

  group('checkAdmin', () {
    test('returns String when http response is successful', () async {
      // Mock the API call to return a json response with http status 200
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call
        final response = "1";
        return Response(jsonEncode(response), 200);
      });
      // Check whether checkAdmin function returns User object
      expect(
          await RemoteService().checkAdmin(mockHTTPClient, 1), isA<String>());
    });

    test('returns null when http response is unsuccessful', () async {
      // Mock the API call to return an empty json response with http status 404
      final mockHTTPClient = MockClient((request) async {
        final response = {};
        return Response(jsonEncode(response), 404);
      });
      // Check whether checkAdmin function returns null
      expect(await RemoteService().checkAdmin(mockHTTPClient, 1), null);
    });
  });

  group('getGates', () {
    test('returns list of Gate objects when http response is successful',
        () async {
      // Mock the API call to return a json response with http status 200
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call
        final response = [
          {
            'id': 1,
            'name': 'test lock',
            'serial_number': '1A2B3C4D5E',
            'magic_code': '12345678-246e-414a-test-12abc6789012',
            'team_id': 1,
            'created_at': '2022-01-01T01:01:01.000Z',
            'updated_at': '2022-01-01T01:01:01.000Z'
          }
        ];
        return Response(jsonEncode(response), 200);
      });
      // Check whether getGates function returns list of Gate objects
      expect(
          await RemoteService().getGates(mockHTTPClient, 1), isA<List<Gate>>());
    });
    test('returns null when http response is unsuccessful', () async {
      // Mock the API call to return an empty json response with http status 404
      final mockHTTPClient = MockClient((request) async {
        final response = {};
        return Response(jsonEncode(response), 404);
      });
      // Check whether getGates function returns null
      expect(await RemoteService().getGates(mockHTTPClient, 1), null);
    });
  });
}
