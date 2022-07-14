import 'package:flutter/material.dart';
import 'package:virtual_key/admin_gates.dart';
import 'package:virtual_key/user_teams.dart';
import 'package:virtual_key/globals.dart';

class UserHub extends StatefulWidget {
  const UserHub({Key? key}) : super(key: key);

  @override
  State<UserHub> createState() => _UserHubState();
}

class _UserHubState extends State<UserHub> {
  int currentIndex = 1;
  final List<Widget> children = const [AdminGates(), UserTeams()];

  void onTappedBar(int index) {
    setState(() {
      if (index == 2) {
        isLogged = false;
        token = null;
        user = null;
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      } else {
        currentIndex = index;
      }
    });
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
