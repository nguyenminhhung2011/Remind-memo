import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/enum/type.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/core/extensions/handle_time.dart';
import 'package:project/core/extensions/int_extension.dart';
import 'package:project/core/widgets/button_custom.dart';
import 'package:project/feature/list_contact/notifier/contact_notifier.dart';
import 'package:project/feature/paid/notifier/paid_notifier.dart';
import 'package:project/feature/pay_detail/notifier/pay_detail_notifier.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/constant.dart';
import '../../../core/widgets/calculate_custom.dart';
import '../../../core/widgets/text_field_custom.dart';
import '../../../domain/enitites/contact/contact.dart';
import '../../../domain/enitites/pay/pay.dart';
import '../../../domain/enitites/transaction/transaction.dart';
import '../../../generated/l10n.dart';
import '../../auth/notifier/auth_notifier.dart';

class PayDetailScreen extends StatefulWidget {
  const PayDetailScreen({super.key});

  @override
  State<PayDetailScreen> createState() => _PayDetailScreenState();
}

class _PayDetailScreenState extends State<PayDetailScreen> {
  final ValueNotifier<DateTime> _time = ValueNotifier<DateTime>(DateTime.now());
  final TextEditingController _noteController = TextEditingController();
  final ValueNotifier<int> _price = ValueNotifier<int>(0);

  PayDetailNotifier get _payDetail => context.read<PayDetailNotifier>();
  ContactNotifier get _contactNotifier => context.read<ContactNotifier>();
  PaidNotifier get _paid => context.read<PaidNotifier>();

  Future<int> _onUpdatePrice() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) {
        return CalculatorCustom(
          inputPrice: _price.value,
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

  void _onTap(int index) async {
    switch (index) {
      case 0:
        final price = await _onUpdatePrice();
        _price.value = price;
      case 1:
        _time.value = await _onPicTime();
      default:
        {
          // do nothing
        }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _payDetail
          .getTransactionDetail(context.read<PaidNotifier>().pay?.id ?? '');
      _noteController.text = _payDetail.transaction?.note ?? '';
      _time.value = _payDetail.transaction?.notificationTIme ?? DateTime.now();
      _price.value = _payDetail.transaction?.price ?? 0;
    });
  }   

  @override
  void dispose() {
    super.dispose();
  }

  void _onDeletePaid() async {
    final delete = await context.showYesNoDialog(
        350, S.current.delete, S.current.deleteTransaction);
    if (delete) {
      final deleteSuccess = await _payDetail.deleteTransaction(
        _payDetail.transactionId,
        _paid.pay?.id ?? '',
      );
      if(deleteSuccess){
        await updateAll(false);
        // ignore: use_build_context_synchronously
        context.pop();
      }
    }
  }

  Future<void> updateAll(bool isUpdate) async {
    bool lend = _payDetail.transaction?.type.isLend ?? false;
    final oldPrice = _payDetail.transaction?.price ?? 0;
    await _paid.updatePaid(Pay(
      id: _paid.pay?.id ?? '',
      // ignore: use_build_context_synchronously
      uuid: context.read<AuthNotifier>().user.uid,
      name: _paid.pay?.name ?? '',
      lendAmount: lend
          ? (_paid.pay!.lendAmount - oldPrice + (isUpdate ? _price.value : 0))
          : _paid.pay?.lendAmount ?? 0,
      loanAmount: lend
          ? _paid.pay?.loanAmount ?? 0
          : (_paid.pay!.loanAmount - oldPrice + (isUpdate ? _price.value : 0)),
    ));
    final contactGet = _contactNotifier.mapContacts[_payDetail.contactId];
    final newContact = Contact(
      id: _payDetail.contactId,
      name: contactGet?.name ?? '',
      phoneNumber: contactGet?.phoneNumber ?? '',
      note: contactGet?.note ?? '',
      type: contactGet?.type ?? 0,
      count: contactGet!.count - (!isUpdate ? 1 : 0),
      price: contactGet.price +
          oldPrice * (lend ? -1 : 1) +
          (isUpdate ? (_price.value) * (lend ? 1 : -1) : 0),
    );
    await _contactNotifier.updateContact(
      newContact,
      _paid.pay?.id ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PayDetailNotifier>(builder: (context, modal, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        extendBody: true,
        bottomSheet: Padding(
          padding: const EdgeInsets.all(Constant.kHMarginCard),
          child: ButtonCustom(
            loading: modal.loadingButton,
            height: 45.0,
            onPress: () async {
              final update = await _payDetail.updateTransactions(
                TransactionEntity(
                  id: _payDetail.transactionId,
                  price: _price.value,
                  contactId: _payDetail.contactId,
                  note: _noteController.text,
                  createTime:
                      _payDetail.transaction?.createTime ?? DateTime.now(),
                  notificationTIme: _time.value,
                  type: _payDetail.transaction?.type ?? TypeTransaction.lend,
                ),
                _paid.pay?.id ?? '',
              );
              if (update) {
                await updateAll(true);
                // ignore: use_build_context_synchronously
                context.pop();
              }
            },
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
                  if (modal.loading)
                    Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  else
                    _body(context),
                ],
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      );
    });
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
                        ValueListenableBuilder(
                          valueListenable: _price,
                          builder: (context, price, child) {
                            return Text(
                              price.price,
                              style: context.headlineMedium.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          },
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
                                getYmdFormat(
                                  _payDetail.transaction?.createTime ??
                                      DateTime.now(),
                                ),
                                getjmFormat(
                                  _payDetail.transaction?.createTime ??
                                      DateTime.now(),
                                )
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
                          _contactNotifier
                                  .mapContacts[_payDetail.contactId]?.name ??
                              '',
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
                    child: GestureDetector(
                      onTap: () => _onTap(1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15.0),
                          Text(
                            getYmdHmFormat(_time.value),
                            style: context.titleMedium
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5.0),
                          Divider(color: Theme.of(context).hintColor),
                        ],
                      ),
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
                controller: _noteController,
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
          onPressed: _onDeletePaid,
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
