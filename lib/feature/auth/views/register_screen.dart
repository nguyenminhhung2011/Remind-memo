import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:project/domain/enitites/user_entity.dart';
import 'package:project/feature/auth/notifier/register_notifier.dart';
import '../../../generated/l10n.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/constant.dart';
import '../../../core/constant/image_const.dart';
import '../../../core/widgets/app_name.dart';
import '../../../core/widgets/button_custom.dart';
import '../../../core/widgets/text_field_custom.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController(text: 'hungnguyen.201102ak@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: '12345678');
  final TextEditingController _rePasswordController = TextEditingController(text: '12345678');
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

  void _submitSignUp(RegisterNotifier modal) async{
    if (_emailController.text.isEmpty) {
      log("email is null");
      return;
    }
    if (_passwordController.text.isEmpty) {
      log("password is null");
      return;
    }
    if (_rePasswordController.text.isEmpty) {
      log("re_pass is null");
      return;
    }
    if (_rePasswordController.text == _passwordController.text) {
    } else {
      log("re pass is invalid");
      return;
    }
    final user = UserEntity(
      email: _emailController.text,
      password: _rePasswordController.text,

    );
    final register =await modal.onSignUp(user);
    if(!register ){
      log('Error');
      return;

    }
    // ignore: use_build_context_synchronously
    context.pop();
    
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

    return Consumer<RegisterNotifier>(
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
                hintText: S.of(context).enterYourNewPassword,
                spacingText: 10.0,
                controller: _passwordController,
                prefix: const Icon(Icons.lock_outline),
                textStyle: textStyle,
              ),
              TextFieldCustom(
                type: TextFieldType.backgroundShadow,
                paddingLeft: Constant.kHMarginCard,
                isPasswordField: true,
                paddingRight: Constant.kHMarginCard,
                headerText: S.of(context).rePassword,
                headerTextStyle: headerStyle,
                hintStyle: context.titleMedium.copyWith(
                  color: Theme.of(context).hintColor,
                ),
                hintText: S.of(context).enterYourPassword,
                spacingText: 10.0,
                controller: _rePasswordController,
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
                    loading:modal.loadingSignUp,
                    child: Text(
                      S.of(context).signUp,
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPress: () => _submitSignUp(modal),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(S.of(context).alreadyHaveAccount,
                      style: context.titleSmall.copyWith(color: Colors.grey)),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      S.of(context).signIn,
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
                S.of(context).orSignUpWith,
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
