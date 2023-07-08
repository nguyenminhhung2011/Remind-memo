import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/constant/constant.dart';
import 'package:project/core/constant/image_const.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/core/extensions/handle_time.dart';
import 'package:project/core/widgets/button_custom.dart';
import 'package:project/feature/add_pay/notifier/add_pay_notifier.dart';
import 'package:project/feature/contact_detail/notifier/contact_detail_notifier.dart';
import 'package:project/feature/paid/notifier/paid_notifier.dart';
import 'package:project/generated/l10n.dart';
import 'package:project/routes/routes.dart';
import 'package:provider/provider.dart';

class ContactDetailScreen extends StatefulWidget {
  const ContactDetailScreen({super.key});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  ContactDetailNotifier get _notifier => context.read<ContactDetailNotifier>();
  List<String> headers = [
    'Title',
    'Loan amount',
    'Lend amount',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifier.getContactAndSetPay(context.read<PaidNotifier>().pay?.id ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactDetailNotifier>(
      builder: (context, modal, child) {
        if (modal.loadingGet) {
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
                    child: Text(S.of(context).loanAdd),
                    onPress: () => context.openPageWithRouteAndParams(
                      Routes.addPay,
                      AddPayArguments(contactId: 0, loan: true),
                    ),
                  )),
                  const SizedBox(width: Constant.kHMarginCard),
                  Expanded(
                      child: ButtonCustom(
                    height: 45.0,
                    child: Text(S.of(context).lendAdd),
                    onPress: () => context.openPageWithRouteAndParams(
                      Routes.addPay,
                      AddPayArguments(contactId: 0, loan: false),
                    ),
                  )),
                ],
              ),
            ),
            appBar: _appBar(context),
            body: Column(
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
                              modal.contact?.price.toString() ?? '0',
                              textAlign: TextAlign.end,
                              style: context.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
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
          for (int i = 0; i < 7; i++)
            ItemPayView(
              createTime: DateTime.now(),
              dueTime: DateTime.now(),
              isLoan: i % 3 == 0,
              price: (i + 1) * 100000,
            )
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
        ],
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.edit,
            color: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}

class ItemPayView extends StatelessWidget {
  final DateTime createTime;
  final DateTime dueTime;
  final bool isLoan;
  final int price;
  const ItemPayView({
    super.key,
    required this.createTime,
    required this.dueTime,
    required this.isLoan,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  isLoan ? '- $price' : '',
                  style: context.titleMedium.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
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
                  !isLoan ? '+ $price' : '',
                  style: context.titleMedium.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
