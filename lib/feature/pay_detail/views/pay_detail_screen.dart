import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/core/widgets/button_custom.dart';

import '../../../core/constant/constant.dart';
import '../../../generated/l10n.dart';

class PayDetailScreen extends StatefulWidget {
  const PayDetailScreen({super.key});

  @override
  State<PayDetailScreen> createState() => _PayDetailScreenState();
}

class _PayDetailScreenState extends State<PayDetailScreen> {
  Future<int> _onUpdatePrice() async {
    return 0;
  }

  void _onTap(int index) async {
    switch (index) {
      case 0:
        final price = await _onUpdatePrice();
      default:
        {
          // do nothing
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.heightDevice * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: _appBar(context),
          ),
          const SizedBox(height: 10.0),
          _body(context),
          Padding(
            padding: const EdgeInsets.all(Constant.kHMarginCard),
            child: ButtonCustom(
              height: 45.0,
              onPress: () {},
              child: Text(S.of(context).update),
            ),
          )
        ],
      ),
    );
  }

  Expanded _body(BuildContext context) {
    final smallStyle = context.titleMedium.copyWith(
        color: Theme.of(context).hintColor, fontWeight: FontWeight.w400);
    return Expanded(
      child: ListView(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Constant.kHMarginCard),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
            ),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).amountOfMoney),
                        const Divider(),
                      ],
                    ),
                  ))
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Row _appBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).primaryColor,
            size: 35.0,
          ),
        ),
        Expanded(
          child: Text(
            S.of(context).payDetails,
            textAlign: TextAlign.center,
            style: context.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
            size: 35.0,
          ),
        ),
      ],
    );
  }
}
