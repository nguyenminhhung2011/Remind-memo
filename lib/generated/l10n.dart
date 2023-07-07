// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Manage your debts easily,\nmoney lending at your fingertips!`
  String get slogan {
    return Intl.message(
      'Manage your debts easily,\nmoney lending at your fingertips!',
      name: 'slogan',
      desc: '',
      args: [],
    );
  }

  /// `Skip for now`
  String get skipForNow {
    return Intl.message(
      'Skip for now',
      name: 'skipForNow',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueText {
    return Intl.message(
      'Continue',
      name: 'continueText',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Register New Account`
  String get registerNewAccount {
    return Intl.message(
      'Register New Account',
      name: 'registerNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `RePassword`
  String get rePassword {
    return Intl.message(
      'RePassword',
      name: 'rePassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password again`
  String get enterRePassword {
    return Intl.message(
      'Enter your password again',
      name: 'enterRePassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message(
      'Sign Out',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `Or sign in with`
  String get orSignInWith {
    return Intl.message(
      'Or sign in with',
      name: 'orSignInWith',
      desc: '',
      args: [],
    );
  }

  /// `Or sign up with`
  String get orSignUpWith {
    return Intl.message(
      'Or sign up with',
      name: 'orSignUpWith',
      desc: '',
      args: [],
    );
  }

  /// `Google`
  String get google {
    return Intl.message(
      'Google',
      name: 'google',
      desc: '',
      args: [],
    );
  }

  /// `Facebook`
  String get facebook {
    return Intl.message(
      'Facebook',
      name: 'facebook',
      desc: '',
      args: [],
    );
  }

  /// `Already have account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Pay type`
  String get payType {
    return Intl.message(
      'Pay type',
      name: 'payType',
      desc: '',
      args: [],
    );
  }

  /// `Search anyThings`
  String get searchAnyThing {
    return Intl.message(
      'Search anyThings',
      name: 'searchAnyThing',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get logIn {
    return Intl.message(
      'Log In',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account ?`
  String get donHaveAnAccount {
    return Intl.message(
      'Don\'t have an account ?',
      name: 'donHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please ! Contact Administrator to be provided Account!`
  String get pleaseContact {
    return Intl.message(
      'Please ! Contact Administrator to be provided Account!',
      name: 'pleaseContact',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your New Password`
  String get enterYourNewPassword {
    return Intl.message(
      'Enter Your New Password',
      name: 'enterYourNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Create Your New Password`
  String get createYourNewPassword {
    return Intl.message(
      'Create Your New Password',
      name: 'createYourNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reenter Your Password`
  String get reenterYourPassword {
    return Intl.message(
      'Reenter Your Password',
      name: 'reenterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reenter Password`
  String get reenterPassword {
    return Intl.message(
      'Reenter Password',
      name: 'reenterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Apply New Password`
  String get applyNewPassword {
    return Intl.message(
      'Apply New Password',
      name: 'applyNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter your email to find your account`
  String get pleaseEnterEmailToFindAccount {
    return Intl.message(
      'Please Enter your email to find your account',
      name: 'pleaseEnterEmailToFindAccount',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message(
      'Or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Accounts receivables`
  String get accountsReceivables {
    return Intl.message(
      'Accounts receivables',
      name: 'accountsReceivables',
      desc: '',
      args: [],
    );
  }

  /// `Accounts payable`
  String get accountsPayable {
    return Intl.message(
      'Accounts payable',
      name: 'accountsPayable',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterYourEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your Password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Overview`
  String get overview {
    return Intl.message(
      'Overview',
      name: 'overview',
      desc: '',
      args: [],
    );
  }

  /// `all`
  String get all {
    return Intl.message(
      'all',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Add new contact`
  String get addNewContact {
    return Intl.message(
      'Add new contact',
      name: 'addNewContact',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choose {
    return Intl.message(
      'Choose',
      name: 'choose',
      desc: '',
      args: [],
    );
  }

  /// `Transaction`
  String get transaction {
    return Intl.message(
      'Transaction',
      name: 'transaction',
      desc: '',
      args: [],
    );
  }

  /// `Chart view`
  String get chartView {
    return Intl.message(
      'Chart view',
      name: 'chartView',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Add lend`
  String get lendAdd {
    return Intl.message(
      'Add lend',
      name: 'lendAdd',
      desc: '',
      args: [],
    );
  }

  /// `Add loan`
  String get loanAdd {
    return Intl.message(
      'Add loan',
      name: 'loanAdd',
      desc: '',
      args: [],
    );
  }

  /// `Add new pay`
  String get addNewPay {
    return Intl.message(
      'Add new pay',
      name: 'addNewPay',
      desc: '',
      args: [],
    );
  }

  /// `Select icon`
  String get selectedIcon {
    return Intl.message(
      'Select icon',
      name: 'selectedIcon',
      desc: '',
      args: [],
    );
  }

  /// `Loan Amount`
  String get loanAmount {
    return Intl.message(
      'Loan Amount',
      name: 'loanAmount',
      desc: '',
      args: [],
    );
  }

  /// `Lend Amount`
  String get lendAmount {
    return Intl.message(
      'Lend Amount',
      name: 'lendAmount',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get enterYourName {
    return Intl.message(
      'Enter your name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterYourPhoneNumber {
    return Intl.message(
      'Enter your phone number',
      name: 'enterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Add from address book`
  String get addFromAddressBook {
    return Intl.message(
      'Add from address book',
      name: 'addFromAddressBook',
      desc: '',
      args: [],
    );
  }

  /// `Sort By Price`
  String get sortByPrice {
    return Intl.message(
      'Sort By Price',
      name: 'sortByPrice',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter name`
  String get enterName {
    return Intl.message(
      'Enter name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Pay Detail`
  String get payDetails {
    return Intl.message(
      'Pay Detail',
      name: 'payDetails',
      desc: '',
      args: [],
    );
  }

  /// `Amount of money`
  String get amountOfMoney {
    return Intl.message(
      'Amount of money',
      name: 'amountOfMoney',
      desc: '',
      args: [],
    );
  }

  /// `Enter note`
  String get enterNote {
    return Intl.message(
      'Enter note',
      name: 'enterNote',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Select pay`
  String get selectedPay {
    return Intl.message(
      'Select pay',
      name: 'selectedPay',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
