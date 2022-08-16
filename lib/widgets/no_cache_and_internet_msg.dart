import 'package:flutter/cupertino.dart';

class NoCacheAndInternet extends StatelessWidget {
  const NoCacheAndInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Cannot read data from cache nor from the internet',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
