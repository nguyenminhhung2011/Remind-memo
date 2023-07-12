import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/constant/constant.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/feature/auth/notifier/auth_notifier.dart';
import 'package:project/feature/paid/notifier/paid_notifier.dart';
import 'package:project/routes/routes.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/drop_down_button_custom.dart';
import '../../../generated/l10n.dart';
import '../../../langugae_change_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void logOut() async {
    final delete = await context.showYesNoDialog(
        350, S.current.signOut, S.current.signOutDescription);
    if (delete) {
      // ignore: use_build_context_synchronously
      context.read<AuthNotifier>().onSignOut();
      // ignore: use_build_context_synchronously
      context.pushAndRemoveAll(Routes.login);
    }
  }

  void _onTap(int index) {
    switch (index) {
      case 3:
        logOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthNotifier, PaidNotifier, LanguageChangeProvider>(
        builder: (context, authModal, paidModal, langModal, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.settings),
              const SizedBox(width: 10.0),
              Text(S.of(context).settings)
            ],
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  authModal.user.profileUrl.isEmpty
                      ? Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                              child: Text(
                            authModal.user.name[0].toUpperCase(),
                            style: context.titleLarge,
                          )),
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(authModal.user.profileUrl),
                              )),
                        ),
                  Text(
                    authModal.user.name,
                    style: context.headlineSmall.copyWith(
                      color: context.titleLarge.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    authModal.user.email,
                    style: context.titleSmall.copyWith(
                      color: context.titleLarge.color,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ]
                    .expand(
                        (element) => [element, const SizedBox(height: 10.0)])
                    .toList()
                  ..removeLast(),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Constant.kHMarginCard),
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  ...<Map<String, dynamic>>[
                    {
                      "title": S.of(context).lendAmount,
                      "icon": Icons.payments_sharp,
                    },
                    {
                      "title": S.of(context).loanAmount,
                      "icon": Icons.price_change,
                    },
                    {
                      "title": S.of(context).language,
                      "icon": Icons.language,
                    },
                    {
                      "title": S.of(context).signOut,
                      "icon": Icons.logout,
                    },
                  ].mapIndexed(
                    (index, e) => GestureDetector(
                      onTap: () => _onTap(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Icon(
                              e['icon'] as IconData,
                              color: index == 3
                                  ? Colors.red
                                  : Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                e['title'].toString(),
                                style: context.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (index == 2)
                              DropdownButtonCustom<Locale?>(
                                width: 100.0,
                                radius: 10.0,
                                value: langModal.currentLocale,
                                onChange: (value) => langModal.changeLocale(
                                  value ?? const Locale('en'),
                                ),
                                items: S.delegate.supportedLocales
                                    .map<DropdownMenuItem<Locale>>(
                                      (Locale value) =>
                                          DropdownMenuItem<Locale>(
                                        value: value,
                                        child: Text(
                                          value.languageCode,
                                          style: context.titleSmall.copyWith(
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            else
                              Text(
                                switch (index) {
                                  0 =>
                                    (paidModal.pay?.lendAmount ?? 0).toString(),
                                  1 =>
                                    (paidModal.pay?.loanAmount ?? 0).toString(),
                                  _ => '',
                                }
                                    .toString(),
                                style: context.titleSmall.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  )
                ].expand((element) => [element, const Divider()]).toList()
                  ..removeLast(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
