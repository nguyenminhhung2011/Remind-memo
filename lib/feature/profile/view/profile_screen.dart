import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:project/core/constant/constant.dart';
import 'package:project/core/extensions/context_exntions.dart';

import '../../../generated/l10n.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(child: Text('H', style: context.titleLarge)),
                ),
                Text(
                  'Hung Nguyen',
                  style: context.headlineSmall.copyWith(
                    color: context.titleLarge.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'hungnguyen.201102a@gmail.com',
                  style: context.titleSmall.copyWith(
                    color: context.titleLarge.color,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ]
                  .expand((element) => [element, const SizedBox(height: 10.0)])
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
                    "title": S.of(context).signOut,
                    "icon": Icons.logout,
                  },
                ].mapIndexed(
                  (index, e) => GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Icon(
                            e['icon'] as IconData,
                            color: index == 2
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
                          Text(
                            switch (index) {
                              0 => '32.124',
                              1 => '23.234',
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
  }
}
