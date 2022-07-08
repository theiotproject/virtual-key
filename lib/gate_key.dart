import 'package:flutter/material.dart';

class GateKey extends StatelessWidget {
  const GateKey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gate name'),
      ),
      body: const Center(
        child: Text('test'),
      ),
    );
  }
}
