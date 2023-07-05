import 'package:flutter/material.dart';
import 'package:project/core/extensions/context_exntions.dart';

class AppName extends StatelessWidget {
  final double? fontSize;
  const AppName({
    super.key,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'Remind',
          style: context.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: fontSize),
        ),
        TextSpan(
          text: ' Memo',
          style: context.titleLarge
              .copyWith(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
      ]),
    );
  }
}
