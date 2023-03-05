import 'package:flutter/material.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/utils/urls.dart';

class SellerAdsProvider extends ChangeNotifier {
  String? _currentLang;

  void update(AuthProvider authProvider) {
    _currentLang = authProvider.currentLang;
  }

  ApiProvider _apiProvider = ApiProvider();

  Future<List<Ad>> getAdsList(String? userId) async {
    final response = await _apiProvider
        .get(Urls.ADS_SELLER_URL + "user_id=$userId&api_lang=$_currentLang");
    List<Ad> adsList = <Ad>[];
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }
}
