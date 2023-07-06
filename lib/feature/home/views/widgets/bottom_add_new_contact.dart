import 'dart:ui';

import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';

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
  Future<List<Contact>> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      return await FastContacts.getAllContacts();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    var headerTextStyle = context.titleMedium
        .copyWith(fontWeight: FontWeight.w400, color: Colors.grey);
    return Container(
      height: context.heightDevice * 0.7,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
        color: Theme.of(context).cardColor,
      ),

      child: Column(
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
          Padding(
            padding: const EdgeInsets.only(left: Constant.kHMarginCard),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    S.of(context).addFromAddressBook,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      S.of(context).choose,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ))
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                TextFieldCustom(
                  paddingLeft: Constant.kHMarginCard,
                  paddingRight: Constant.kHMarginCard,
                  headerText: S.of(context).name,
                  hintText: S.of(context).enterName,
                  headerTextStyle: headerTextStyle,
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
                  headerTextStyle: headerTextStyle,
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
                  headerTextStyle: headerTextStyle,
                  hintStyle: headerTextStyle,
                  hintText: S.of(context).enterNote,
                  controller: _noteController,
                  textStyle: headerTextStyle.copyWith(
                    color: context.titleLarge.color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Constant.kHMarginCard),
            child: ButtonCustom(
              height: 45.0,
              child: Text(S.of(context).addNewContact),
              onPress: () {},
            ),
          ),
        ].expand((element) => [element, const SizedBox(height: 6.0)]).toList(),
      ),
    );
  }
}
