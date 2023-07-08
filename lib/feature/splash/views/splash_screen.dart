import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/data/data_source/preferences.dart';
import 'package:project/feature/auth/notifier/auth_notifier.dart';
import 'package:project/feature/paid/notifier/paid_notifier.dart';
import 'package:project/routes/routes.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/image_const.dart';
import '../../../core/widgets/app_name.dart';
import '../../../generated/l10n.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkingAuthentication(BuildContext context) async {
    Future.delayed(const Duration(seconds: 3)).whenComplete(() async {
      final isShow =
          await context.read<AuthNotifier>().checkingAuthentication();
      if (isShow) {
        // ignore: use_build_context_synchronously
        await context.read<AuthNotifier>().getAndSetUser().then((value) async{
          if (value) {
            // ignore: use_build_context_synchronously
            final paidGet = CommonAppSettingPref.getPayId();
            if (paidGet.isEmpty) {
              context.pushAndRemoveAll(Routes.paid);
            } else {
              await context.read<PaidNotifier>().getPayAndSetPay(paidGet);
              // ignore: use_build_context_synchronously
              context.pushAndRemoveAll(Routes.dashboard);
            }
          }
        });
      } else {
        // ignore: use_build_context_synchronously
        context.pushAndRemoveAll(Routes.onboard);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkingAuthentication(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: context.widthDevice * 0.3,
              height: context.widthDevice * 0.3,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(ImageConst.gif),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const AppName(),
            Text(
              S.of(context).slogan,
              textAlign: TextAlign.center,
              style: context.titleSmall.copyWith(
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10.0),
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              strokeWidth: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}
