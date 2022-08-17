import 'package:flutter/cupertino.dart';

class EmptyListText extends StatelessWidget {
  final String title;
  
  const EmptyListText(
    {Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}