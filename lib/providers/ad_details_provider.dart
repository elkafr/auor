import 'package:flutter/material.dart';
import 'package:auor/models/ad_details.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/utils/urls.dart';

class AdDetailsProvider extends ChangeNotifier {
  String? _currentLang;

  void update(AuthProvider authProvider) {
    _currentLang = authProvider.currentLang;
  }

  ApiProvider _apiProvider = ApiProvider();

  Future<AdDetails> getAdDetails(String? adId) async {
    final response = await _apiProvider
        .get(Urls.AD_DETAILS_URL + 'id=$adId&api_lang=$_currentLang');
    AdDetails adDetails = AdDetails();
    if (response['response'] == '1') {
      adDetails = AdDetails.fromJson(response['details']);
    }
    return adDetails;
  }
}
