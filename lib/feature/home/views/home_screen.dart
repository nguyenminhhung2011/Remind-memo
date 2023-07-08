import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/constant/constant.dart';
import 'package:project/core/constant/image_const.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/core/extensions/handle_time.dart';
import 'package:project/core/widgets/header_text_custom.dart';
import 'package:project/core/widgets/sort_button.dart';
import 'package:project/feature/auth/notifier/auth_notifier.dart';
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
        TypeView.all => "all view",
        TypeView.lend => "lend",
        _ => "loan",
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

  AuthNotifier get _auth => context.read<AuthNotifier>();
  PaidNotifier get _paid => context.read<PaidNotifier>();

  final ValueNotifier<DateTime> _currentTime =
      ValueNotifier<DateTime>(DateTime.now());

  void _onChangeTab(TypeView view) {
    _typeView.value = view;
  }

  void _onShowPayDetail() async {
    final show = await showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return ChangeNotifierProvider<PayDetailNotifier>.value(
            value: PayDetailNotifier(),
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
        if(show is bool && show){
          // ignore: use_build_context_synchronously
          context.read<ContactNotifier>().getContacts(_paid.pay?.id ?? '');
        }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PaidNotifier, AuthNotifier>(
      builder: (context, paidModal, authModal, child) {
        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: ButtonCustom(
              radius: 5.0,
              width: context.widthDevice * 0.4,
              onPress: () {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).addNewPay,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.add),
                ],
              ),
            ),
          ),
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
                    SortButton(
                      title: S.of(context).sortByPrice,
                      // height: 50,
                      icon: Icons.sort,
                      onPress: () {},
                    ),
                    const Spacer(),
                    ValueListenableBuilder<TypeView>(
                      valueListenable: _typeView,
                      builder: (context, typeView, child) {
                        return DropdownButtonCustom<TypeView?>(
                          borderColor: Colors.transparent,
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
                  ],
                ),
              ),
              const Divider(),
              Container(
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
                          '${_currentTime.value.day < 10 ? '0' : ''}${_currentTime.value.day}',
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
                              ...getMMMMEEEd(_currentTime.value)
                                  .split(',')
                                  .mapIndexed(
                                    (index, e) => Text(
                                      index == 0
                                          ? e.trim()
                                          : '${e.trim()} ${_currentTime.value.year}',
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
                        Text(
                          ' ${123.013}',
                          style: context.titleSmall.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    const Divider(),
                    const SizedBox(height: 5.0),
                    ...[1, 0, 1, 1, 0]
                        .map(
                          (e) => ItemView(
                            onPress: _onShowPayDetail,
                            name: 'Nguyen Minh Hung',
                            time: DateTime.now()
                                .subtract(const Duration(hours: 10)),
                            price: 123.2,
                            isPay: e == 1,
                          ),
                        )
                        .expand((element) => [
                              element,
                              const SizedBox(height: 15.0),
                            ])
                  ],
                ),
              ),
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
          ),
        )
      ],
    );
  }
}

class SelectPaid extends StatelessWidget {
  const SelectPaid({
    super.key,
  });

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
                padding: const EdgeInsets.symmetric(horizontal: Constant.kHMarginCard),
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
