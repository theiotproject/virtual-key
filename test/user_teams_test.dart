/*
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:virtual_key/models/team.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/user_teams.dart';

class MockRemoteSerivce extends Mock implements RemoteService {}

void main() {
  late MockRemoteSerivce mockRemoteSerivce;

  setUp(() {
    mockRemoteSerivce = MockRemoteSerivce();
  });

  final teamsFromService = [
    Team(
      id: 1,
      userId: 1,
      name: "Test Team",
      personalTeam: true,
      createdAt: DateTime.parse("2022-01-01T01:01:01.000000Z"),
      updatedAt: DateTime.parse("2022-01-01T01:01:01.000000Z"),
    ),
    Team(
      id: 2,
      userId: 1,
      name: "Test Team 2",
      personalTeam: false,
      createdAt: DateTime.parse("2022-01-01T01:01:01.000000Z"),
      updatedAt: DateTime.parse("2022-01-01T01:01:01.000000Z"),
    ),
    Team(
      id: 3,
      userId: 1,
      name: "Test Team 3",
      personalTeam: false,
      createdAt: DateTime.parse("2022-01-01T01:01:01.000000Z"),
      updatedAt: DateTime.parse("2022-01-01T01:01:01.000000Z"),
    )
  ];

  void arrangeRemoteServiceReturns3Teams() {
    when(() => mockRemoteSerivce.getTeams(1))
        .thenAnswer((_) async => teamsFromService);
  }

  Widget widgetUnderTest = const MediaQuery(
      data: MediaQueryData(), child: MaterialApp(home: UserTeams()));

  testWidgets("title is displayed", (WidgetTester tester) async {
    arrangeRemoteServiceReturns3Teams();
    await tester.pumpWidget(widgetUnderTest);
    expect(find.text('Your teams'), findsOneWidget);
  });
}
*/