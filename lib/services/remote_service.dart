import 'package:virtual_key/models/gate.dart';
import 'package:http/http.dart' as http;

class RemoteService {
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
