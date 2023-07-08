import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/domain/enitites/contact/contact.dart';
import 'package:project/feature/list_contact/notifier/contact_notifier.dart';
import 'package:project/feature/paid/notifier/paid_notifier.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/constant.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/text_field_custom.dart';
import '../../../../generated/l10n.dart';

class BottomAddNewContact extends StatefulWidget {
  const BottomAddNewContact({
    super.key,
  });

  @override
  State<BottomAddNewContact> createState() => _BottomAddNewContactState();
}

class _BottomAddNewContactState extends State<BottomAddNewContact> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final ValueNotifier<int> _iconIndex = ValueNotifier<int>(0);
  ContactNotifier get _contactNotifier => context.read<ContactNotifier>();
  Future<List<Contact>> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      // return await FastContacts.getAllContacts();
    }
    return [];
  }

  void addContact() async {
    final add = await _contactNotifier.addContact(
      Contact(
        id: '',
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        note: _noteController.text,
        type: _iconIndex.value,
        count: 0,
        price: 0,
      ),
      context.read<PaidNotifier>().pay?.id ?? '',
    );
    if (add) {
      // ignore: use_build_context_synchronously
      context.pop();
    }
  }

  void _onSelectIcon() async {
    final pic = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).selectedIcon,
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10.0),
                Wrap(
                  children: [
                    ...Constant.icons.mapIndexed(
                      (index, e) => GestureDetector(
                        onTap: () => context.popArgs(index),
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          margin: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (e['color'] as Color).withOpacity(0.5),
                          ),
                          child: Center(
                            child: Text(
                              e['icon'].toString(),
                              style: context.titleMedium,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    if (pic != null && pic is int) {
      _iconIndex.value = pic;
    }
  }

  @override
  Widget build(BuildContext context) {
    var headerTextStyle = context.titleMedium
        .copyWith(fontWeight: FontWeight.w400, color: Colors.grey);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          SizedBox(height: context.heightDevice * 0.3),
          Container(
            height: context.heightDevice * 0.7,
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      S.of(context).addNewContact,
                      style: context.titleLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                const Divider(),
                TextFieldCustom(
                  paddingLeft: Constant.kHMarginCard,
                  paddingRight: Constant.kHMarginCard,
                  headerText: S.of(context).name,
                  hintText: S.of(context).enterName,
                  headerTextStyle: headerTextStyle.copyWith(
                    color: context.titleLarge.color,
                  ),
                  hintStyle: headerTextStyle,
                  controller: _nameController,
                  textStyle: headerTextStyle.copyWith(
                    color: context.titleLarge.color,
                  ),
                ),
                const SizedBox(height: 6.0),
                TextFieldCustom(
                  paddingLeft: Constant.kHMarginCard,
                  paddingRight: Constant.kHMarginCard,
                  headerText: S.of(context).phoneNumber,
                  hintText: S.of(context).enterPhoneNumber,
                  isPhoneNumberField: true,
                  headerTextStyle: headerTextStyle.copyWith(
                    color: context.titleLarge.color,
                  ),
                  isNumberInputType: true,
                  hintStyle: headerTextStyle,
                  controller: _phoneController,
                  textStyle: headerTextStyle.copyWith(
                    color: context.titleLarge.color,
                  ),
                ),
                const SizedBox(height: 6.0),
                TextFieldCustom(
                  paddingLeft: Constant.kHMarginCard,
                  paddingRight: Constant.kHMarginCard,
                  headerText: S.of(context).note,
                  headerTextStyle: headerTextStyle.copyWith(
                    color: context.titleLarge.color,
                  ),
                  hintStyle: headerTextStyle,
                  hintText: S.of(context).enterNote,
                  controller: _noteController,
                  textStyle: headerTextStyle.copyWith(
                    color: context.titleLarge.color,
                  ),
                ),
                const SizedBox(height: 6.0),
                Padding(
                  padding: const EdgeInsets.only(left: Constant.kHMarginCard),
                  child: Text(
                    S.of(context).selectedIcon,
                    style: headerTextStyle.copyWith(
                      color: context.titleLarge.color,
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _iconIndex,
                  builder: (context, iconIndex, child) {
                    return InkWell(
                      onTap: _onSelectIcon,
                      child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: Constant.kHMarginCard,
                            vertical: 5.0,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              width: 1.5,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 80.0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 5.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: (Constant.icons[iconIndex]['color']
                                          as Color)
                                      .withOpacity(0.5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      Constant.icons[iconIndex]['icon']
                                          .toString(),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                    );
                  },
                ),
                Consumer<ContactNotifier>(builder: (context, modal, child) {
                  return Padding(
                    padding: const EdgeInsets.all(Constant.kHMarginCard),
                    child: ButtonCustom(
                      height: 45.0,
                      loading: modal.loadingButton,
                      enableClick: _nameController.text.isNotEmpty,
                      child: Text(S.of(context).addNewContact),
                      onPress: () => addContact(),
                    ),
                  );
                })
              ]
                  .expand((element) => [element, const SizedBox(height: 6.0)])
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
