import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_key/models/team.dart';
import 'fixture/fixture_reader.dart';

void main() {
  final tTeamModel = Team(
    id: 1,
    userId: 1,
    name: 'test team',
    personalTeam: true,
    createdAt: DateTime.parse('2022-01-01T01:01:01.000000Z'),
    updatedAt: DateTime.parse('2022-01-01T01:01:01.000000Z'),
    teamCode: '20TEST10QW',
  );

  group('fromJson', () {
    test(
      'make sure the fromJson function returns a valid model object when reading valid JSON',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('team_model.json'));

        final result = Team.fromJson(jsonMap);
        
        expect(result, tTeamModel);
      },
    );
  });

  group('toJson', () {
    test(
      'make sure the toJson function returns a JSON value in the form of a valid map object when converting model data to JSON',
      () async {
        final resultTeamModel = tTeamModel.toJson();

        final expectedTeamModel = {
          'id': 1,
          'user_id': 1,
          'name': 'test team',
          'personal_team': true,
          'created_at': '2022-01-01T01:01:01.000Z',
          'updated_at': '2022-01-01T01:01:01.000Z',
          'team_code': '20TEST10QW',
        };

        expect(resultTeamModel, expectedTeamModel);
      },
    );
  });
}
