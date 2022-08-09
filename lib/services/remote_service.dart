import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/user.dart';
import 'package:virtual_key/models/team.dart';
import 'package:virtual_key/models/gate.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_key/models/virtual_key.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<User?> getUser(http.Client client) async {
    String fileName = "userPath.json";
    var dir = await getTemporaryDirectory();
    File file = File('${dir.path}/${fileName}');

    var internetConnection = await Connectivity().checkConnectivity();
    if (internetConnection != ConnectivityResult.none) {
      print('fetch from api');
      Uri uri = Uri.parse('https://keymanager.theiotproject.com/api/user');
      http.Response response = await client.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        String json = response.body;

        file.writeAsStringSync(json, flush: true, mode: FileMode.write);
        return userFromJson(json);
      }
    } else if (file.existsSync()) {
      print('reading from cache');

      final data = file.readAsStringSync();
      return userFromJson(data);
    }
  }

  Future<List<Team>?> getTeams(http.Client client, userId) async {
    String fileName = "teamsPath.json";
    var dir = await getTemporaryDirectory();
    File file = File('${dir.path}/${fileName}');

    var internetConnection = await Connectivity().checkConnectivity();
    if (internetConnection != ConnectivityResult.none) {
      print('fetch from api');
      Uri uri = Uri.parse(
          'https://keymanager.theiotproject.com/api/teams/userId/${userId}');
      http.Response response = await client.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        String json = response.body;

        file.writeAsStringSync(json, flush: true, mode: FileMode.write);
        return teamFromJson(json);
      }
    } else if (file.existsSync()) {
      print('reading from cache');

      final data = file.readAsStringSync();
      return teamFromJson(data);
    }
  }

  Future<List<VirtualKey>?> getKeys(http.Client client, teamId) async {
    String fileName = "keys${teamId}Path.json";
    var dir = await getTemporaryDirectory();
    File file = File('${dir.path}/${fileName}');

    var internetConnection = await Connectivity().checkConnectivity();
    if (internetConnection != ConnectivityResult.none) {
      print('fetch from api');
      Uri uri = Uri.parse(
          'https://keymanager.theiotproject.com/api/virtualKeys/teamId/${teamId}/token');
      http.Response response = await client.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        String json = response.body;

        file.writeAsStringSync(json, flush: true, mode: FileMode.write);
        return virtualKeyFromJson(json);
      }
    } else if (file.existsSync()) {
      print('reading from cache');

      final data = file.readAsStringSync();
      return virtualKeyFromJson(data);
    }
  }

  Future<List<Gate>?> getKeyGates(http.Client client, virtualKeyId) async {
    String fileName = "keyGates${virtualKeyId}Path.json";
    var dir = await getTemporaryDirectory();
    File file = File('${dir.path}/${fileName}');

    var internetConnection = await Connectivity().checkConnectivity();
    if (internetConnection != ConnectivityResult.none) {
      print('fetch from api');
      Uri uri = Uri.parse(
          'https://keymanager.theiotproject.com/api/gates/virtualKeyId/${virtualKeyId}');
      http.Response response = await client.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        String json = response.body;

        file.writeAsStringSync(json, flush: true, mode: FileMode.write);
        return gateFromJson(json);
      }
    } else if (file.existsSync()) {
      print('reading from cache');

      final data = file.readAsStringSync();
      return gateFromJson(data);
    }
  }

  Future<String?> getTeamCode(http.Client client, teamId) async {
    String fileName = "getTeamCode${teamId}Path.json";
    var dir = await getTemporaryDirectory();
    File file = File('${dir.path}/${fileName}');

    var internetConnection = await Connectivity().checkConnectivity();
    if (internetConnection != ConnectivityResult.none) {
      print('fetch from api');
      Uri uri = Uri.parse(
          'https://keymanager.theiotproject.com/api/virtualKeys/code/${teamId}');
      http.Response response = await client.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        file.writeAsStringSync(response.body,
            flush: true, mode: FileMode.write);
        return response.body;
      }
    } else if (file.existsSync()) {
      print('reading from cache');

      final data = file.readAsStringSync();
      return data;
    }
  }

  Future<String?> checkAdmin(http.Client client, teamId) async {
    String fileName = "checkAdmin${teamId}Path.json";
    var dir = await getTemporaryDirectory();
    File file = File('${dir.path}/${fileName}');

    var internetConnection = await Connectivity().checkConnectivity();
    if (internetConnection != ConnectivityResult.none) {
      print('fetch from api');
      Uri uri = Uri.parse(
          'https://keymanager.theiotproject.com/api/auth/permission/teamId/${teamId}/request');
      http.Response response = await client.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        file.writeAsStringSync(response.body,
            flush: true, mode: FileMode.write);
        return response.body;
      }
    } else if (file.existsSync()) {
      print('reading from cache');

      final data = file.readAsStringSync();
      return data;
    }
  }

  Future<List<Gate>?> getGates(http.Client client, teamId) async {
    String fileName = "gates${teamId}Path.json";
    var dir = await getTemporaryDirectory();
    File file = File('${dir.path}/${fileName}');

    var internetConnection = await Connectivity().checkConnectivity();
    if (internetConnection != ConnectivityResult.none) {
      Uri uri = Uri.parse(
          'https://keymanager.theiotproject.com/api/gates/teamId/${teamId}');
      http.Response response = await client.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        String json = response.body;

        file.writeAsStringSync(json, flush: true, mode: FileMode.write);
        return gateFromJson(json);
      }
    } else if (file.existsSync()) {
      print('reading from cache');

      final data = file.readAsStringSync();
      return gateFromJson(data);
    }
  }

  Future sendKeyCodeGenerationEvent(
      String id, int virtualKeyId, bool accessGranted, String message) async {
    String fileName = "keyCodeEventPath.json";
    var dir = await getTemporaryDirectory();
    File file = File('${dir.path}/${fileName}');

    var internetConnection = await Connectivity().checkConnectivity();
    if (internetConnection != ConnectivityResult.none &&
        file.existsSync() == false) {
      generateKeyUsageEvent(id, virtualKeyId, accessGranted, message);
    } else if (internetConnection != ConnectivityResult.none &&
        file.existsSync() == true) {
      // send previous events
      String fileData = file.readAsStringSync();
      fileData = fileData.substring(0, fileData.length - 1);

      List<String> events = fileData.split('@');
      events.forEach((event) async {
        final parsedJson = jsonDecode(event);

        await generateKeyUsageEvent(
            parsedJson['id'],
            parsedJson['virtual_key_id'],
            parsedJson['access_granted'],
            parsedJson['message']);
      });

      file.delete();

      // send current event
      await generateKeyUsageEvent(id, virtualKeyId, accessGranted, message);
    } else {
      final data = jsonEncode(<String, dynamic>{
        'id': id,
        'virtual_key_id': virtualKeyId,
        'access_granted': accessGranted,
        'message': message
      });
      file.writeAsStringSync('${data}@', flush: true, mode: FileMode.append);
    }
  }

  Future<http.Response> generateKeyUsageEvent(
      String id, int virtualKeyId, bool accessGranted, String message) {
    return http.post(
      Uri.parse('https://keymanager.theiotproject.com/api/keyUsages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'virtual_key_id': virtualKeyId,
        'access_granted': accessGranted,
        'message': message
      }),
    );
  }

  Future sendBackupCodeGenerationEvent(
      String id, String magicCode, String message, int userId) async {
    String fileName = "magicCodeEventPath.json";
    var dir = await getTemporaryDirectory();
    File file = File('${dir.path}/${fileName}');

    var internetConnection = await Connectivity().checkConnectivity();
    if (internetConnection != ConnectivityResult.none &&
        file.existsSync() == false) {
      generateMagicUsageEvent(id, magicCode, message, userId);
    } else if (internetConnection != ConnectivityResult.none &&
        file.existsSync() == true) {
      // send previous events
      String fileData = file.readAsStringSync();
      fileData = fileData.substring(0, fileData.length - 1);

      List<String> events = fileData.split('@');
      events.forEach((event) async {
        final parsedJson = jsonDecode(event);

        await generateMagicUsageEvent(
            parsedJson['id'],
            parsedJson['magic_code'],
            parsedJson['message'],
            parsedJson['user_id']);
      });

      file.delete();

      // send current event
      await generateMagicUsageEvent(id, magicCode, message, userId);
    } else {
      final data = jsonEncode(<String, dynamic>{
        'id': id,
        'magic_code': magicCode,
        'message': message,
        'user_id': userId
      });
      file.writeAsStringSync('${data}@', flush: true, mode: FileMode.append);
    }
  }

  Future<http.Response> generateMagicUsageEvent(
      String id, String magicCode, String message, int userId) {
    return http.post(
      Uri.parse('https://keymanager.theiotproject.com/api/magicCodeUsages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'magic_code': magicCode,
        'message': message,
        'user_id': userId
      }),
    );
  }
}
