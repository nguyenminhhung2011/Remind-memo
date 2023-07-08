import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/constant/constant.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/core/widgets/button_custom.dart';
import 'package:project/data/data_source/preferences.dart';
// import 'package:project/domain/enitites/pay/pay.dart';
import 'package:project/feature/auth/notifier/auth_notifier.dart';
import 'package:project/feature/paid/notifier/paid_notifier.dart';
import 'package:project/routes/routes.dart';
import 'package:provider/provider.dart';

// import '../../../core/widgets/drop_down_button_custom.dart';
import '../../../core/widgets/text_field_custom.dart';
import '../../../generated/l10n.dart';

class PaidScreen extends StatefulWidget {
  const PaidScreen({super.key});

  @override
  State<PaidScreen> createState() => _PaidScreenState();
}

class _PaidScreenState extends State<PaidScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaidNotifier>().getPays();
    });
  }

  void _addNewPaid() async {
    final add = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      )),
      builder: (context) => const BottomAddPaid(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaidNotifier>(
      builder: (context, modal, child) {
        if (modal.loadingGet) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(Constant.kHMarginCard),
            child: ButtonCustom(
              onPress: _addNewPaid,
              height: 45.0,
              child: Text(S.of(context).addNewPay),
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                Icon(Icons.price_change, color: Theme.of(context).primaryColor),
                const SizedBox(width: 10.0),
                Text(
                  S.of(context).selectedPay,
                  style:
                      context.titleLarge.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Constant.kHMarginCard),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              ...modal.listPay
                  .map((e) => ButtonCustom(
                        borderColor: Theme.of(context).primaryColor,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        onPress: () async {
                          modal.setPaid(e);
                          if (modal.pay != null) {
                            final save = await CommonAppSettingPref.setPayId(
                                modal.pay?.id ?? '');
                            if (save) {
                              // ignore: use_build_context_synchronously
                              context.pushAndRemoveAll(Routes.dashboard);
                            }
                          }
                        },
                        height: 45.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(e.name, textAlign: TextAlign.start,
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
            ]),
          ),
        );
      },
    );
  }
}

class BottomAddPaid extends StatefulWidget {
  const BottomAddPaid({
    super.key,
  });

  @override
  State<BottomAddPaid> createState() => _BottomAddPaidState();
}

class _BottomAddPaidState extends State<BottomAddPaid> {
  final TextEditingController _name = TextEditingController();
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var headerTextStyle = context.titleMedium
        .copyWith(fontWeight: FontWeight.w400, color: Colors.grey);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Constant.kHMarginCard),
        child: ButtonCustom(
          loading: context.read<PaidNotifier>().loadingButton,
          onPress: () async {
            final add = await context
                .read<PaidNotifier>()
                .addNewPaid(_name.text, context.read<AuthNotifier>().user.uid);
            if (add) {
              // ignore: use_build_context_synchronously
              context.pop();
            }
          },
          height: 45.0,
          child: Text(S.of(context).addNewPay),
        ),
      ),
      body: Column(
        children: [
          TextFieldCustom(
            paddingLeft: Constant.kHMarginCard,
            paddingRight: Constant.kHMarginCard,
            headerText: S.of(context).name,
            hintText: S.of(context).enterName,
            headerTextStyle: headerTextStyle.copyWith(
              color: context.titleLarge.color,
            ),
            hintStyle: headerTextStyle,
            controller: _name,
            textStyle: headerTextStyle.copyWith(
              color: context.titleLarge.color,
            ),
          ),
        ],
      ),
    );
  }
}
