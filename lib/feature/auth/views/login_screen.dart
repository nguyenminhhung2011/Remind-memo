import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';

import '../../../core/constant/constant.dart';
import '../../../core/constant/image_const.dart';
import '../../../core/widgets/app_name.dart';
import '../../../core/widgets/button_custom.dart';
import '../../../core/widgets/text_field_custom.dart';
import '../../../generated/l10n.dart';
import '../../../routes/routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    var headerStyle = context.titleMedium.copyWith(
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    );
    var textStyle = context.titleMedium.copyWith(
      fontWeight: FontWeight.w400,
    );

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
            padding:
                const EdgeInsets.symmetric(horizontal: Constant.kHMarginCard),
            child: SizedBox(
              height: 50.0,
              child: ButtonCustom(
                  loading: _loading.value,
                  child: Text(
                    S.of(context).signIn,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPress: () => context.pushAndRemoveAll(Routes.dashboard)
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.of(context).donHaveAnAccount,
                  style: context.titleSmall.copyWith(color: Colors.grey)),
              TextButton(
                onPressed: () {},
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
                onPress: () {},
              ),
            ),
          ),
        ].expand((element) => [element, const SizedBox(height: 10.0)]).toList(),
      ),
    );
  }
}
