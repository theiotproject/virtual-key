import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_key/models/user.dart';
import 'fixture/fixture_reader.dart';

void main() {
  final tUserModel = User(
      id: 1,
      name: 'test',
      email: 'test@test.com',
      emailVerifiedAt: DateTime.parse('2022-01-01T01:01:01.000000Z'),
      currentTeamId: 1,
      createdAt: DateTime.parse('2022-01-01T01:01:01.000000Z'),
      updatedAt: DateTime.parse('2022-01-01T01:01:01.000000Z'),
      profilePhotoUrl: '');

  group('fromJson', () {
    test(
      'make sure the fromJson function returns a valid model object when reading valid JSON',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('user_model.json'));

        final result = User.fromJson(jsonMap);

        expect(result, tUserModel);
      },
    );
  });

  group('toJson', () {
    test(
      'make sure the toJson function returns a JSON value in the form of a valid map object when converting model data to JSON',
      () async {
        final resultUserModel = tUserModel.toJson();

        final expectedUserModel = {
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

        expect(resultUserModel, expectedUserModel);
      },
    );
  });
}
