import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';

import '../../../../generated/l10n.dart';
import '../constant/image_const.dart';
import 'button_custom.dart';

enum StatusDialog {
  yes,
  no;

  bool get isYes => this == StatusDialog.yes;
}

class YesNoDialog extends StatelessWidget {
  final double? width;
  final String header;
  final String title;
  const YesNoDialog({
    super.key,
    this.width,
    required this.header,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ImageConst.gif, width: 70, height: 70),
          Text(header,
              textAlign: TextAlign.center,
              style: context.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              )),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                  child: ButtonCustom(
                onPress: () => context.popArgs(StatusDialog.yes),
                radius: 5,
                child: Text(S.of(context).yes),
              )),
              const SizedBox(width: 10.0),
              Expanded(
                  child: ButtonCustom(
                onPress: () => context.popArgs(StatusDialog.no),
                radius: 5,
                color: Colors.red,
                child: Text(S.of(context).no),
              ))
            ],
          ),
        ].expand((element) => [element, const SizedBox(height: 10.0)]).toList()
          ..removeLast(),
      ),
    );
  }
}
