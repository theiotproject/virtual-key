import 'package:virtual_key/models/team.dart';
import 'package:virtual_key/models/gate.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  Future<List<Team>?> getTeams() async {
    http.Client client = http.Client();

    Uri uri =
        Uri.parse('https://mocki.io/v1/455fb9ac-6f70-4792-8d4c-67c9452d7514');
    http.Response response = await client.get(uri);

    if (response.statusCode == 200) {
      String json = response.body;

      return teamFromJson(json);
    }
  }

  Future<List<Gate>?> getGates() async {
    http.Client client = http.Client();

    Uri uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    http.Response response = await client.get(uri);

    if (response.statusCode == 200) {
      String json = response.body;
      return gateFromJson(json);
    }
  }
}
