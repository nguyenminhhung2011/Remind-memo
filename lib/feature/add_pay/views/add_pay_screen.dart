import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/core/widgets/button_custom.dart';
import 'package:project/feature/add_pay/notifier/add_pay_notifier.dart';
import 'package:project/generated/l10n.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/constant.dart';
import '../../../core/extensions/handle_time.dart';
import '../../../core/widgets/calculate_custom.dart';
import '../../../core/widgets/drop_down_button_custom.dart';
import '../../../core/widgets/text_field_custom.dart';

class AddPayScreen extends StatefulWidget {
  const AddPayScreen({super.key});

  @override
  State<AddPayScreen> createState() => _AddPayScreenState();
}

class _AddPayScreenState extends State<AddPayScreen> {
  final ValueNotifier<DateTime> _time = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<DateTime> _dueTime =
      ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<String> _type = ValueNotifier<String>('loan');

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
    if (result != null && result is int) {
      return result;
    }
    return 0;
  }

  Future<DateTime> _onPicTime() async {
    final result = await context.pickDateTime();
    return result ?? DateTime.now();
  }

  Future<dynamic> _onChooseContact() async {
    final choose = await showDialog(
      context: context,
      builder: (context) => Dialog(
          insetPadding: const EdgeInsets.all(10.0),
          backgroundColor: Colors.transparent,
          child: ChangeNotifierProvider.value(
            value: ChooseContactNotifier(),
            child: const ChooseContact(),
          )),
    );
  }

  void _onTap(int index) async {
    switch (index) {
      case 0:
        final price = await _onUpdatePrice();
      case 1:
        _time.value = await _onPicTime();
      case 2:
        _dueTime.value = await _onPicTime();
      case 3:
        _onChooseContact();
      default:
        {
          // do nothing
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPayNotifier>(
      builder: (context, modal, child) {
        if (!modal.loan) {
          _type.value = 'lend';
        }
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back, color: context.titleLarge.color),
            ),
            title: Text(
              S.of(context).addNewPay,
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(child: _body(context, modal)),
              Padding(
                padding: const EdgeInsets.all(Constant.kHMarginCard),
                child: ButtonCustom(
                  onPress: () {},
                  height: 45.0,
                  child: Text(S.of(context).addNewPay),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, AddPayNotifier modal) {
    final smallStyle = context.titleMedium.copyWith(
        color: Theme.of(context).hintColor, fontWeight: FontWeight.w300);
    return ListView(
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
                      onTap: () => _onTap(1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15.0),
                          ValueListenableBuilder(
                            valueListenable: _time,
                            builder: (context, time, child) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ...<String>[
                                    getYmdFormat(time),
                                    getjmFormat(time)
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
                                            color:
                                                Theme.of(context).primaryColor,
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
                                        (element) => [
                                          element,
                                          const SizedBox(width: 6.0)
                                        ],
                                      )
                                ],
                              );
                            },
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
                    child: GestureDetector(
                      onTap: () => modal.contactId == -1 ? _onTap(3) : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15.0),
                          Text(
                            'Nguyen Minh Hung',
                            style: context.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Divider(color: Theme.of(context).hintColor),
                        ],
                      ),
                    ),
                  ), 
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: DropdownButtonCustom<String?>(
                      // borderColor: Colors.transparent,
                      width: 120.0,
                      radius: 10.0,
                      headerText: S.of(context).payType,
                      value: _type.value,
                      onChange: (value) {},
                      items: ['loan', 'lend']
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: context.titleSmall.copyWith(
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          )
                          .toList(),
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
                  ValueListenableBuilder(
                    valueListenable: _dueTime,
                    builder: (context, dueTime, child) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _onTap(2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15.0),
                              Text(
                                getYmdHmFormat(dueTime),
                                style: context.titleMedium
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5.0),
                              Divider(color: Theme.of(context).hintColor),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
}

class ChooseContactNotifier extends ChangeNotifier {}

class ChooseContact extends StatelessWidget {
  const ChooseContact({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ChooseContactNotifier>(
      builder: (context, modal, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              _searchField(context, modal),
              Expanded(
                  child: ListView(
                children: [
                  ...[0, 1, 2, 3, 4, 5, 6, 7, 8].map(
                    (e) => GestureDetector(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: (Constant.icons[e]['color'] as Color)
                              .withOpacity(0.5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              'Nguyen Minh Hung $e',
                              style: context.titleMedium.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                            Text(Constant.icons[e]['icon'].toString())
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: ButtonCustom(
                  height: 45.0,
                  onPress: () => context.popArgs(-1),
                  radius: 5.0,
                  child: Text(S.of(context).choose),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _searchField(BuildContext context, ChooseContactNotifier modal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        height: 45.0,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: TextFormField(
          onChanged: (value) {},
          decoration: InputDecoration(
            filled: true,
            hintText: S.of(context).searchAnyThing,
            hintStyle: context.titleSmall.copyWith(color: Colors.grey),
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          ),
        ),
      ),
    );
  }
}
