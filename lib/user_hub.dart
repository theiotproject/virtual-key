import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtual_key/admin_teams.dart';
import 'package:virtual_key/user_keys.dart';
import 'package:virtual_key/globals.dart';

class UserHub extends StatefulWidget {
  const UserHub({Key? key}) : super(key: key);

  @override
  State<UserHub> createState() => _UserHubState();
}

class _UserHubState extends State<UserHub> {
  final storage = const FlutterSecureStorage();

  int currentIndex = 1;
  final List<Widget> children = const [AdminTeams(), UserKeys()];

  void onTappedBar(int index) {
    setState(() {
      if (index == 2) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Logout'),
              content: Text('Are you sure you want to logout?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Logout'),
                  onPressed: () {
                    isLogged = false;
                    token = '';
                    user = null;

                    deleteTokenFromStorage();
                    deleteCachedData();

                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (_) => false);
                  },
                ),
              ],
            );
          },
        );
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
    return WillPopScope(
      onWillPop: () async {
        // block system back arrow
        return false;
      },
      child: Scaffold(
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
      ),
    );
  }
}
