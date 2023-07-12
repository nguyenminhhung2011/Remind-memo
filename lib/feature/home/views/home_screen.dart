import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/constant/constant.dart';
import 'package:project/core/constant/image_const.dart';
import 'package:project/core/dependency_injection/di.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/core/extensions/handle_time.dart';
import 'package:project/core/widgets/header_text_custom.dart';
import 'package:project/core/widgets/range_date_picker_custom.dart';
import 'package:project/core/widgets/sort_button.dart';
import 'package:project/feature/auth/notifier/auth_notifier.dart';
import 'package:project/feature/chart/notifier/chart_notifier.dart';
import 'package:project/feature/home/notifier/home_notifier.dart';
import 'package:project/feature/home/views/widgets/item_view.dart';
import 'package:project/feature/list_contact/notifier/contact_notifier.dart';
import 'package:project/feature/paid/notifier/paid_notifier.dart';
import 'package:project/feature/pay_detail/notifier/pay_detail_notifier.dart';
import 'package:project/feature/pay_detail/views/pay_detail_screen.dart';
import 'package:project/generated/l10n.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/button_custom.dart';
import '../../../core/widgets/drop_down_button_custom.dart';
import '../../../data/data_source/preferences.dart';

enum TypeView {
  all,
  lend,
  loan;

  String get displayValue => switch (this) {
        TypeView.all => S.current.all,
        TypeView.lend => S.current.lend,
        _ => S.current.loan,
      };
  int get toInt => switch (this) {
        TypeView.all => -1,
        TypeView.lend => 0,
        _ => 1,
      };
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<TypeView> _typeView =
      ValueNotifier<TypeView>(TypeView.all);

  final _rangeDateController = RangeDateController();

  AuthNotifier get _auth => context.read<AuthNotifier>();
  PaidNotifier get _paid => context.read<PaidNotifier>();
  HomeNotifier get _home => context.read<HomeNotifier>();
  ContactNotifier get _contact => context.read<ContactNotifier>();
  ChartNotifier get _chart => context.read<ChartNotifier>();

  void _onChangeTab(TypeView view) {
    _typeView.value = view;
    _home.getTransactions(_paid.pay?.id ?? '', view.toInt);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _home.getTransactions(_paid.pay?.id ?? '', -1);
      _contact.getMapContacts(_paid.pay?.id ?? '');
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

  void _onShowSelectedPaid() async {
    final show = await showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return const SelectPaid();
        });
    if (show is bool && show) {
      String paidId = _paid.pay?.id ?? '';
      // ignore: use_build_context_synchronously
      _contact.getContacts(paidId);
      _home.getTransactions(paidId, -1);
      _contact.getMapContacts(paidId);
      _chart.getData(_rangeDateController.listDateUI, paidId);
    }
  }

  @override
  void dispose() {
    _rangeDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<PaidNotifier, AuthNotifier, HomeNotifier, ContactNotifier>(
      builder: (context, paidModal, authModal, homeModal, contactModal, child) {
        if (_contact.loadingGet1) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            toolbarHeight: 80,
            elevation: 0,
            title: _appBar(context),
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              const SizedBox(height: 5.0),
              HeaderTextCustom(
                padding: const EdgeInsets.only(left: Constant.kHMarginCard),
                headerText: S.of(context).overview,
                textStyle: context.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                isShowSeeMore: true,
                afterText: S.of(context).all,
              ),
              _overviewField(context),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: Constant.kHMarginCard),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    ValueListenableBuilder<TypeView>(
                      valueListenable: _typeView,
                      builder: (context, typeView, child) {
                        return DropdownButtonCustom<TypeView?>(
                          width: 120.0,
                          radius: 10.0,
                          value: typeView,
                          onChange: (value) => _onChangeTab(value!),
                          items: [TypeView.all, TypeView.lend, TypeView.loan]
                              .map<DropdownMenuItem<TypeView>>(
                                (TypeView value) => DropdownMenuItem<TypeView>(
                                  value: value,
                                  child: Text(
                                    value.displayValue,
                                    style: context.titleSmall.copyWith(
                                        fontWeight: FontWeight.w400,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(width: Constant.kHMarginCard)
                  ],
                ),
              ),
              const Divider(),
              if (homeModal.loadingGet)
                Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              else
                ...homeModal.listTransaction.entries.map<Widget>(
                  (element) => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Constant.kHMarginCard),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.03),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${element.key.day < 10 ? '0' : ''}${element.key.day}',
                              style: context.headlineLarge.copyWith(
                                color: context.titleMedium.color,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...getMMMMEEEd(element.key)
                                      .split(',')
                                      .mapIndexed(
                                        (index, e) => Text(
                                          index == 0
                                              ? e.trim()
                                              : '${e.trim()} ${element.key.year}',
                                          style: context.titleSmall.copyWith(
                                            color: Theme.of(context).hintColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )
                                ],
                              ),
                            ),
                            Icon(
                              Icons.bar_chart_sharp,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        const Divider(),
                        const SizedBox(height: 5.0),
                        ...element.value
                            .map((e) => ItemView(
                                  name: contactModal
                                          .mapContacts[e.contactId]?.name ??
                                      'Hung',
                                  time: e.createTime,
                                  price: e.price.toDouble(),
                                  isPay: e.type.isLend,
                                  onPress: () =>
                                      _onShowPayDetail(e.id, e.contactId),
                                ))
                            .expand((element) =>
                                [element, const SizedBox(height: 8.0)])
                      ],
                    ),
                  ),
                )
            ]
                .expand((element) => [element, const SizedBox(height: 5.0)])
                .toList(),
          ),
        );
      },
    );
  }

  Container _overviewField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: Constant.kHMarginCard),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Row(
        children: [
          ...<Map<String, dynamic>>[
            {
              'price': _paid.pay?.lendAmount ?? 0,
              'header': S.of(context).lendAmount,
              'color': Colors.green,
            },
            {
              'price': _paid.pay?.loanAmount ?? 0,
              'header': S.of(context).loanAmount,
              'color': Colors.red,
            },
          ]
              .map(
                (e) => Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10.0),
                      Text(
                        e['price'].toString(),
                        style: context.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: e['color'] as Color),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        e['header'].toString(),
                        style: context.titleSmall.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      )
                    ],
                  ),
                ),
              )
              .expand((element) => [element, const VerticalDivider()])
              .toList()
            ..removeLast()
        ],
      ),
    );
  }

  Row _appBar(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 5.0,
                ),
              ],
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    ImageConst.avatarDefaults,
                  ))),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _auth.user.name,
                style: context.titleLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                'This is Bio',
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).hintColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        ButtonCustom(
          enableWidth: false,
          borderColor: Theme.of(context).primaryColor,
          color: Theme.of(context).scaffoldBackgroundColor,
          onPress: _onShowSelectedPaid,
          child: Text(
            _paid.pay?.name ?? '',
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

class SelectPaid extends StatefulWidget {
  const SelectPaid({
    super.key,
  });

  @override
  State<SelectPaid> createState() => _SelectPaidState();
}

class _SelectPaidState extends State<SelectPaid> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaidNotifier>().getPays();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaidNotifier>(builder: (context, modal, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        extendBody: true,
        // bottomSheet: Padding(
        //   padding: const EdgeInsets.all(Constant.kHMarginCard),
        //   child: ButtonCustom(
        //     height: 45.0,
        //     onPress: () {},
        //     child: Text(S.of(context).update),
        //   ),
        // ),
        body: Column(
          children: [
            const SizedBox(height: 5.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close),
                ),
                Text(
                  S.of(context).selectedPay,
                  style: context.titleLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constant.kHMarginCard),
                child: ListView(
                  children: [
                    ...modal.listPay
                        .map((e) => ButtonCustom(
                              borderColor: Theme.of(context).primaryColor,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              onPress: () async {
                                modal.setPaid(e);
                                if (modal.pay != null) {
                                  final save =
                                      await CommonAppSettingPref.setPayId(
                                          modal.pay?.id ?? '');
                                  if (save) {
                                    // ignore: use_build_context_synchronously
                                    context.popArgs(true);
                                  }
                                }
                              },
                              height: 45.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    e.name,
                                    textAlign: TextAlign.start,
                                    style: context.titleMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .expand((element) => [
                              element,
                              const SizedBox(
                                height: 10.0,
                              )
                            ])
                        .toList(),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
