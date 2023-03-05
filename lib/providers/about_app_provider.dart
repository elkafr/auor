import 'package:flutter/material.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/utils/urls.dart';

class AboutAppProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  String? _currentLang;

  void update(AuthProvider authProvider) {
    _currentLang = authProvider.currentLang;
  }

  Future<String?> getAboutApp() async {
    final response =
        await _apiProvider.get(Urls.ABOUT_APP_URL + "?api_lang=$_currentLang");
    String? aboutApp = '';
    if (response['response'] == '1') {
      aboutApp = response['messages'];
    }
    return aboutApp;
  }

  Future<String?> getPolicyApp() async {
    final response = await _apiProvider
        .get("http://auor-app.com/api/policy" + "?api_lang=$_currentLang");
    String? aboutApp = '';
    if (response['response'] == '1') {
      aboutApp = response['messages'];
    }
    return aboutApp;
  }
}
