import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/data_source/preferences.dart';

import 'generated/l10n.dart';

@injectable
class LanguageChangeProvider with ChangeNotifier {
  LanguageChangeProvider() {
    init();
  }

  void init() async {
    final langCode = CommonAppSettingPref.getLanguage();
    if (langCode == null) {
      await CommonAppSettingPref.setLanguage('en');
    }
    int local = switch (langCode ?? 0) { 'en' => 0, _ => 1 };
    _currentLocale = S.delegate.supportedLocales[local];
    notifyListeners();
  }

  Locale _currentLocale = S.delegate.supportedLocales[0];

  Locale get currentLocale => _currentLocale;

  void changeLocale(Locale local) async{
    _currentLocale = local;
    await CommonAppSettingPref.setLanguage(local.languageCode);
    notifyListeners();
  }
}
