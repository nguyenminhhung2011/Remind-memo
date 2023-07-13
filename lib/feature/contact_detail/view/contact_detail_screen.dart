import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/constant/constant.dart';
import 'package:project/core/constant/image_const.dart';
import 'package:project/core/dependency_injection/di.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/core/extensions/handle_time.dart';
import 'package:project/core/extensions/int_extension.dart';
import 'package:project/core/widgets/button_custom.dart';
import 'package:project/domain/enitites/contact/contact.dart';
import 'package:project/domain/enitites/pay/pay.dart';
import 'package:project/feature/add_pay/notifier/add_pay_notifier.dart';
import 'package:project/feature/contact_detail/notifier/contact_detail_notifier.dart';
import 'package:project/feature/paid/notifier/paid_notifier.dart';
import 'package:project/feature/pdf/pad_preview.dart';
import 'package:project/generated/l10n.dart';
import 'package:project/routes/routes.dart';
import 'package:provider/provider.dart';

import '../../auth/notifier/auth_notifier.dart';
import '../../list_contact/notifier/contact_notifier.dart';
import '../../pay_detail/notifier/pay_detail_notifier.dart';
import '../../pay_detail/views/pay_detail_screen.dart';

class ContactDetailScreen extends StatefulWidget {
  const ContactDetailScreen({super.key});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  ContactDetailNotifier get _notifier => context.read<ContactDetailNotifier>();
  ContactNotifier get _contactNotifier => context.read<ContactNotifier>();
  PaidNotifier get _paid => context.read<PaidNotifier>();
  List<String> headers = [
    S.current.time,
    S.current.loanAmount,
    S.current.lendAmount,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String paidId = context.read<PaidNotifier>().pay?.id ?? '';
      if (paidId.isNotEmpty) {
        _notifier.getContactAndSetPay(paidId);
        _notifier.getTransactions(paidId);
      }
    });
  }

  void _onShowPayDetail(String transactionId, String contactId) async {
    final show = await showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return ChangeNotifierProvider<PayDetailNotifier>.value(
            value: injector.get(param1: transactionId, param2: contactId),
            child: const PayDetailScreen(),
          );
        });
  }

  Future<void> updateAll(bool isUpdate, bool lend, int oldPrice) async {
    await _paid.updatePaid(Pay(
      id: _paid.pay?.id ?? '',
      // ignore: use_build_context_synchronously
      uuid: context.read<AuthNotifier>().user.uid,
      name: _paid.pay?.name ?? '',
      lendAmount: lend
          ? (_paid.pay!.lendAmount - oldPrice)
          : _paid.pay?.lendAmount ?? 0,
      loanAmount: lend
          ? _paid.pay?.loanAmount ?? 0
          : (_paid.pay!.loanAmount - oldPrice),
    ));
    final contactGet = _notifier.contact;
    final newContact = Contact(
      id: _notifier.contactId,
      name: contactGet?.name ?? '',
      phoneNumber: contactGet?.phoneNumber ?? '',
      note: contactGet?.note ?? '',
      type: contactGet?.type ?? 0,
      count: contactGet!.count - (!isUpdate ? 1 : 0),
      price: contactGet.price + oldPrice * (lend ? -1 : 1),
    );
    await _contactNotifier.updateContact(
      newContact,
      _paid.pay?.id ?? '',
    );
  }

  void _openAddTransaction(bool loan) async {
    final open = await context.openPageWithRouteAndParams(
      Routes.addPay,
      AddPayArguments(contactId: _notifier.contactId, loan: loan),
    );
    if (open != null && open is Contact) {
      _notifier.setContact(open);
    }
  }

  void _onDelete(String transactionId, bool lend, int oldPrice) async {
    final delete = await context.showYesNoDialog(
        350, S.current.delete, S.current.deleteTransaction);
    if (delete) {
      final deleteSuccess = await _paid.deleteTransaction(
        transactionId,
        _paid.pay?.id ?? '',
      );
      if (deleteSuccess) {
        await updateAll(false, lend, oldPrice);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactDetailNotifier>(
      builder: (context, modal, child) {
        if (modal.loadingGet || modal.loadingGet1) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
        return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(Constant.kHMarginCard),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: ButtonCustom(
                          color: Colors.red,
                          height: 45.0,
                          child: Text(
                            S.of(context).loanAdd,
                            textAlign: TextAlign.center,
                          ),
                          onPress: () => _openAddTransaction(true))),
                  const SizedBox(width: Constant.kHMarginCard),
                  Expanded(
                      child: ButtonCustom(
                          height: 45.0,
                          child: Text(
                            S.of(context).lendAdd,
                            textAlign: TextAlign.center,
                          ),
                          onPress: () => _openAddTransaction(false))),
                ],
              ),
            ),
            appBar: _appBar(context),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.all(Constant.kHMarginCard),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            ImageConst.dollar,
                            width: 35.0,
                            height: 35.0,
                          ),
                          Expanded(
                            child: Text(
                              modal.contact?.price.price ?? '0',
                              textAlign: TextAlign.end,
                              style: context.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                const Divider(),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constant.kHMarginCard,
                  ),
                  child: Text(
                    '💰 ${S.of(context).longPressDescription}',
                    overflow: TextOverflow.ellipsis,
                    style: context.titleSmall,
                  ),
                ),
                const SizedBox(height: 10.0),
                _header(context),
                _body(context)
              ],
            ));
      },
    );
  }

  Expanded _body(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          ..._notifier.listTransaction.map((e) => ItemPayView(
                createTime: e.createTime,
                dueTime: e.notificationTIme,
                isLoan: !e.type.isLend,
                price: e.price,
                longPress: () => _onDelete(e.id, e.type.isLend, e.price),
                onPress: () => _onShowPayDetail(e.id, e.contactId),
              ))
        ]
            .expand((element) => [
                  element,
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ])
            .toList(),
      ),
    );
  }

  Container _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Constant.kHMarginCard),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.2),
      ),
      child: Row(
        children: [
          ...[4, 3, 3].mapIndexed(
            (index, e) => Expanded(
              flex: e,
              child: Text(
                headers[index],
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(Icons.arrow_back, color: context.titleLarge.color),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Constant.icons[_notifier.contact?.type ?? 0]['icon'].toString(),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _notifier.contact?.name ?? '',
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '(${_notifier.contact?.phoneNumber ?? ''})',
                  style: context.titleSmall.copyWith(
                    color: Theme.of(context).hintColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          ButtonCustom(
            onPress: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PdfPreviewPage(
                          listTransaction: _notifier.listTransaction,
                          contact: _notifier.contact!,
                        ))),
            enableWidth: false,
            height: 40.0,
            radius: 5.0,
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.white),
                Text(
                  'PDF',
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ItemPayView extends StatelessWidget {
  final DateTime createTime;
  final DateTime dueTime;
  final bool isLoan;
  final int price;
  final Function() longPress;
  final Function() onPress;
  const ItemPayView({
    super.key,
    required this.createTime,
    required this.dueTime,
    required this.isLoan,
    required this.price,
    required this.longPress,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: longPress,
      onTap: onPress,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: Constant.kHMarginCard),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ' ${getYmdHmFormat(createTime)}',
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.notifications,
                          color: Theme.of(context).primaryColor,
                          size: 12,
                        ),
                        Text(
                          ' ${getYmdHmFormat(dueTime)}',
                          style: context.titleSmall.copyWith(
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                height: 50.0,
                color: Colors.red.withOpacity(0.1),
                child: Center(
                  child: Text(
                    isLoan ? '- ${price.price}' : '',
                    style: context.titleMedium.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                height: 50.0,
                color: Colors.green.withOpacity(0.1),
                child: Center(
                  child: Text(
                    !isLoan ? '+ ${price.price}' : '',
                    style: context.titleMedium.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
