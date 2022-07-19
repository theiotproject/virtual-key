import 'dart:convert';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/user.dart';
import 'package:virtual_key/models/team.dart';
import 'package:virtual_key/models/gate.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_key/models/virtual_key.dart';

class RemoteService {
  Future<http.Response> login(String email, String password, String device) {
    return http.post(
      Uri.parse('https://keymanager.theiotproject.com/api/auth/token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'device_name': device
      }),
    );
  }

  Future<User?> getUser() async {
    http.Client client = http.Client();

    Uri uri = Uri.parse('https://keymanager.theiotproject.com/api/user');
    http.Response response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      String json = response.body;
      return userFromJson(json);
    }
  }

  Future<List<Team>?> getTeams(userId) async {
    http.Client client = http.Client();

    Uri uri = Uri.parse(
        'https://keymanager.theiotproject.com/api/teams/userId/${userId}');
    http.Response response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String json = response.body;
      return teamFromJson(json);
    }
  }

  Future<List<VirtualKey>?> getKeys(teamId) async {
    http.Client client = http.Client();

    Uri uri = Uri.parse(
        'https://keymanager.theiotproject.com/api/virtualKeys/teamId/${teamId}/token');
    http.Response response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String json = response.body;
      return virtualKeyFromJson(json);
    }
  }

  Future<String?> getKeyCode(teamId) async {
    http.Client client = http.Client();

    Uri uri = Uri.parse(
        'https://keymanager.theiotproject.com/api/virtualKeys/code/${teamId}');
    http.Response response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future<String?> checkAdmin(teamId) async {
    http.Client client = http.Client();

    Uri uri = Uri.parse(
        'https://keymanager.theiotproject.com/api/auth/permission/teamId/${teamId}/request');
    http.Response response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future<List<Gate>?> getGates(teamId) async {
    http.Client client = http.Client();

    Uri uri = Uri.parse(
        'https://keymanager.theiotproject.com/api/gates/teamId/${teamId}');
    http.Response response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String json = response.body;
      return gateFromJson(json);
    }
  }
}
