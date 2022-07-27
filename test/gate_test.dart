import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_key/models/gate.dart';
import 'fixture/fixture_reader.dart';

void main() {
  final tGateModel = Gate(
    id: 1,
    name: 'test lock',
    serialNumber: '1A2B3C4D5E',
    magicCode: '12345678-246e-414a-test-12abc6789012',
    teamId: 1,
    createdAt: DateTime.parse('2022-01-01T01:01:01.000000Z'),
    updatedAt: DateTime.parse('2022-01-01T01:01:01.000000Z'),
  );

  group('fromJson', () {
    test(
      'make sure the fromJson function returns a valid model object when reading valid JSON',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('gate_model.json'));

        final result = Gate.fromJson(jsonMap);

        expect(result, tGateModel);
      },
    );
  });

  group('toJson', () {
    test(
      'make sure the toJson function returns a JSON value in the form of a valid map object when converting model data to JSON',
      () async {
        final resultGateModel = tGateModel.toJson();

        final expectedGateModel = {
          'id': 1,
          'name': 'test lock',
          'serial_number': '1A2B3C4D5E',
          'magic_code': '12345678-246e-414a-test-12abc6789012',
          'team_id': 1,
          'created_at': DateTime.parse('2022-01-01T01:01:01.000000Z'),
          'updated_at': DateTime.parse('2022-01-01T01:01:01.000000Z')
        };

        expect(resultGateModel, expectedGateModel);
      },
    );
  });
}
