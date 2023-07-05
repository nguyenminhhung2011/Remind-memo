import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/core/extensions/handle_time.dart';
import 'package:project/core/widgets/button_custom.dart';

import '../../../core/constant/constant.dart';
import '../../../core/widgets/calculate_custom.dart';
import '../../../core/widgets/text_field_custom.dart';
import '../../../generated/l10n.dart';

class PayDetailScreen extends StatefulWidget {
  const PayDetailScreen({super.key});

  @override
  State<PayDetailScreen> createState() => _PayDetailScreenState();
}

class _PayDetailScreenState extends State<PayDetailScreen> {
  final ValueNotifier<DateTime> _time = ValueNotifier<DateTime>(DateTime.now());

  Future<int> _onUpdatePrice() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) {
        return const CalculatorCustom(
          inputPrice: 100,
        );
      },
    );
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      bottomSheet: Padding(
        padding: const EdgeInsets.all(Constant.kHMarginCard),
        child: ButtonCustom(
          height: 45.0,
          onPress: () {},
          child: Text(S.of(context).update),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: context.heightDevice * 0.1),
          Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
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
              ],
            ),
          ),
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    final smallStyle = context.titleMedium.copyWith(
        color: Theme.of(context).hintColor, fontWeight: FontWeight.w300);
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: Constant.kHMarginCard),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.03),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 30,
                    child: Icon(
                      Icons.price_change,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                      child: GestureDetector(
                    onTap: () => _onTap(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).amountOfMoney, style: smallStyle),
                        const SizedBox(height: 7.0),
                        Text(
                          '123.324',
                          style: context.headlineMedium.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Divider(color: Theme.of(context).hintColor),
                      ],
                    ),
                  ))
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 30,
                    child: Icon(
                      Icons.date_range,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ...<String>[
                                getYmdFormat(_time.value),
                                getjmFormat(_time.value)
                              ]
                                  .map(
                                    (e) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 7.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: Text(
                                        e,
                                        style: context.titleSmall.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                  .expand(
                                    (element) =>
                                        [element, const SizedBox(width: 6.0)],
                                  )
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          Divider(color: Theme.of(context).hintColor),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 30,
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15.0),
                        Text(
                          'Nguyen Minh Hung',
                          style: context.titleMedium
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5.0),
                        Divider(color: Theme.of(context).hintColor),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 30,
                    child: Icon(
                      Icons.timelapse_sharp,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15.0),
                        Text(
                          getYmdHmFormat(DateTime.now()),
                          style: context.titleMedium
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5.0),
                        Divider(color: Theme.of(context).hintColor),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Constant.kHMarginCard),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.03),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldCustom(
                maxLines: 10,
                headerText: S.of(context).note,
                spacingText: 10.0,
                hintStyle: context.titleMedium,
                hintText: 'Write your note...',
                textStyle: context.titleMedium,
                controller: TextEditingController(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50.0)
      ],
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
