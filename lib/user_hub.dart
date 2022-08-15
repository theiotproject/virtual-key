import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtual_key/admin_teams.dart';
import 'package:virtual_key/user_teams.dart';
import 'package:virtual_key/globals.dart';

class UserHub extends StatefulWidget {
  const UserHub({Key? key}) : super(key: key);

  @override
  State<UserHub> createState() => _UserHubState();
}

class _UserHubState extends State<UserHub> {
  final storage = const FlutterSecureStorage();

  int currentIndex = 1;
  final List<Widget> children = const [AdminTeams(), UserTeams()];

  void onTappedBar(int index) {
    setState(() {
      if (index == 2) {
        isLogged = false;
        token = '';
        user = null;

        deleteTokenFromStorage();
        deleteCachedData();

        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      } else {
        currentIndex = index;
      }
    });
  }

  Future<void> deleteTokenFromStorage() async {
    await storage.write(key: 'KEY_TOKEN', value: '');
  }

  Future<void> deleteCachedData() async {
      var dir = await getTemporaryDirectory();
        dir.deleteSync(recursive: true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: onTappedBar,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.lock),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.key),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
