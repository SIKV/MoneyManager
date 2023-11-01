import 'package:flutter/material.dart';

class SmallSectionText extends StatelessWidget {
  final String text;

  const SmallSectionText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
