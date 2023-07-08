import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/feature/auth/notifier/auth_notifier.dart';
import 'package:project/feature/auth/notifier/login_notifier.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/constant.dart';
import '../../../core/constant/image_const.dart';
import '../../../core/widgets/app_name.dart';
import '../../../core/widgets/button_custom.dart';
import '../../../core/widgets/text_field_custom.dart';
import '../../../data/data_source/preferences.dart';
import '../../../domain/enitites/user_entity.dart';
import '../../../generated/l10n.dart';
import '../../../routes/routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'hungnguyen.201102ak@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '1234567');
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitSignIn(LoginNotifier modal) async {
    if (_emailController.text.isEmpty) {
      log("email is null");
      return;
    }
    if (_passwordController.text.isEmpty) {
      log("password is null");
      return;
    }

    final user = UserEntity(
      email: _emailController.text,
      password: _passwordController.text,
    );
    final signIn = await modal.onSignIn(user);
    if (!signIn) {
      log('Error');
      return;
    }
    final userGet = await modal.getCurrentUser();
    if (userGet == null) {
      log('Error');
      return;
    }
    // ignore: use_build_context_synchronously
    context.read<AuthNotifier>().setUser(userGet);
    final paidGet = CommonAppSettingPref.getPayId();
    if (paidGet.isEmpty) {
      // ignore: use_build_context_synchronously
      context.pushAndRemoveAll(Routes.paid);
    } else {
      // ignore: use_build_context_synchronously
      context.pushAndRemoveAll(Routes.dashboard);
    }

  }

  @override
  Widget build(BuildContext context) {
    var headerStyle = context.titleMedium.copyWith(
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    );
    var textStyle = context.titleMedium.copyWith(
      fontWeight: FontWeight.w400,
    );

    return Consumer<LoginNotifier>(
      builder: (context, modal, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppName(fontSize: 17),
              ],
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              const SizedBox(height: 20.0),
              SizedBox(
                height: context.heightDevice * 0.15,
                child: Image.asset(ImageConst.gif),
              ),
              TextFieldCustom(
                type: TextFieldType.backgroundShadow,
                paddingLeft: Constant.kHMarginCard,
                paddingRight: Constant.kHMarginCard,
                headerText: S.of(context).email,
                headerTextStyle: headerStyle,
                hintStyle: context.titleMedium.copyWith(
                  color: Theme.of(context).hintColor,
                ),
                hintText: S.of(context).enterYourEmail,
                spacingText: 10.0,
                controller: _emailController,
                prefix: const Icon(Icons.email_outlined),
                textStyle: textStyle,
              ),
              const SizedBox(height: 5.0),
              TextFieldCustom(
                type: TextFieldType.backgroundShadow,
                paddingLeft: Constant.kHMarginCard,
                isPasswordField: true,
                paddingRight: Constant.kHMarginCard,
                headerText: S.of(context).password,
                headerTextStyle: headerStyle,
                hintStyle: context.titleMedium.copyWith(
                  color: Theme.of(context).hintColor,
                ),
                hintText: S.of(context).enterYourPassword,
                spacingText: 10.0,
                controller: _passwordController,
                prefix: const Icon(Icons.lock_outline),
                textStyle: textStyle,
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constant.kHMarginCard),
                child: SizedBox(
                  height: 50.0,
                  child: ButtonCustom(
                      loading: modal.loadingSignUp,
                      child: Text(
                        S.of(context).signIn,
                        style: context.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPress: () => _submitSignIn(modal)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(S.of(context).donHaveAnAccount,
                      style: context.titleSmall.copyWith(color: Colors.grey)),
                  TextButton(
                    onPressed: () =>
                        context.openListPageWithRoute(Routes.register),
                    child: Text(
                      S.of(context).signUp,
                      style: context.titleSmall.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              Text(
                S.of(context).orSignInWith,
                textAlign: TextAlign.center,
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constant.kHMarginCard,
                ),
                child: SizedBox(
                  height: 45.0,
                  child: ButtonCustom(
                    color: Theme.of(context).cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ImageConst.googleIcon,
                            height: 30.0, width: 30.0),
                        Text(
                          ' ${S.of(context).google}',
                          style: context.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    onPress: () => modal.onGoogleAuth(),
                  ),
                ),
              ),
            ]
                .expand((element) => [element, const SizedBox(height: 10.0)])
                .toList(),
          ),
        );
      },
    );
  }
}
