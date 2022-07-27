import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_key/models/virtual_key.dart';
import 'fixture/fixture_reader.dart';

void main() {
  final tVirtualKeyModel = VirtualKey(
    id: 1,
    label: 'test',
    userId: 1,
    validDays: 'MFS',
    createdAt: DateTime.parse('2022-01-01T01:01:01.000000Z'),
    updatedAt: DateTime.parse('2022-01-01T01:01:01.000000Z'),
  );

  group('fromJson', () {
    test(
      'make sure the fromJson function returns a valid model object when reading valid JSON',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('virtual_key_model.json'));

        final result = VirtualKey.fromJson(jsonMap);

        expect(result, tVirtualKeyModel);
      },
    );
  });

  group('toJson', () {
    test(
      'make sure the toJson function returns a JSON value in the form of a valid map object when converting model data to JSON',
      () async {
        final resultVirtualKeyModel = tVirtualKeyModel.toJson();

        final expectedVirtualKeyModel = {
          'id': 1,
          'label': 'test',
          'user_id': 1,
          'valid_days': 'MFS',
          'created_at': '2022-01-01T01:01:01.000Z',
          'updated_at': '2022-01-01T01:01:01.000Z',
        };

        expect(resultVirtualKeyModel, expectedVirtualKeyModel);
      },
    );
  });
}
