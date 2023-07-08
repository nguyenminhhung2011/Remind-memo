import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/core/extensions/handle_time.dart';
import 'package:project/feature/list_contact/notifier/contact_notifier.dart';
import 'package:project/feature/paid/notifier/paid_notifier.dart';
import 'package:project/routes/routes.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/constant.dart';
import '../../../core/widgets/button_custom.dart';
import '../../../generated/l10n.dart';
import '../../home/views/widgets/bottom_add_new_contact.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ContactNotifier get _contact => context.read<ContactNotifier>();
  PaidNotifier get _paid => context.read<PaidNotifier>();

  void _onShowBottomAddNewContact() async {
    final add = await showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      // backgroundColor: Theme.of(context).cardColor,
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const BottomAddNewContact();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _contact.getContacts(_paid.pay?.id ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactNotifier>(
      builder: (context, modal, child) {
        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: ButtonCustom(
              radius: 5.0,
              width: context.widthDevice * 0.45,
              onPress: _onShowBottomAddNewContact,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).addNewContact,
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
            title: Row(
              children: [
                Icon(Icons.people, color: context.titleLarge.color),
                const SizedBox(width: 10.0),
                Text(
                  S.of(context).contact,
                  style:
                      context.titleLarge.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _expansionView(context),
            ],
          ),
        );
      },
    );
  }

  ExpansionPanelList _expansionView(BuildContext context) {
    return ExpansionPanelList(
      expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 0,
      animationDuration: const Duration(milliseconds: 300),
      expansionCallback: _contact.onSelectStep,
      children: _contact.listStep
          .map((e) => ExpansionPanel(
                headerBuilder: (context, isExpanded) => GestureDetector(
                  onTap: () =>
                      context.openPageWithRouteAndParams(Routes.contactDetail, e.id),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        margin: const EdgeInsets.symmetric(
                          horizontal: Constant.kHMarginCard,
                          vertical: 10.0,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          e.name[0].toUpperCase(),
                          style: context.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.name,
                              style: context.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${e.count} ${S.of(context).transaction}',
                              style: context.titleSmall.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).hintColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(
                        e.price.toString(),
                        style: context.titleMedium.copyWith(
                          color: e.isPay ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < e.count; i++)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Constant.kHMarginCard * 1.5,
                          vertical: Constant.kHMarginCard,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(
                                i % 2 == 0 ? 0.2 : 0.1,
                              ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (i + 1).toString(),
                              style: context.titleMedium.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...getMMMMEEEd(DateTime.now())
                                      .split(',')
                                      .mapIndexed(
                                        (index, e) => Text(
                                          index == 0
                                              ? e.trim()
                                              : '${e.trim()} ${DateTime.now().year}',
                                          style: context.titleSmall.copyWith(
                                            color: Theme.of(context).hintColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )
                                ],
                              ),
                            ),
                            Text(
                              123.12.toString(),
                              style: context.titleSmall.copyWith(
                                color: i % 2 == 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    const SizedBox(height: 3.0),
                  ],
                ),
                isExpanded: e.isExpanded,
              ))
          .toList(),
    );
  }
}
