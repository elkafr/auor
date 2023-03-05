import 'package:flutter/material.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/models/user.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/utils/urls.dart';

class FavouriteProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  User? _currentUser;
  String? _currentLang;

  void update(AuthProvider authProvider) {
    _currentUser = authProvider.currentUser;
    _currentLang = authProvider.currentLang;
  }

// favourite ads list
  Map<String?, int?> _favouriteAdsList = Map<String?, int?>();

// into didCHange()
  addItemToFavouriteAdsList(String? id, int? value) {
    _favouriteAdsList[id] = value;
  }

  addToFavouriteAdsList(String? id, int value) {
    _favouriteAdsList[id] = value;
    notifyListeners();
  }

  removeFromFavouriteAdsList(String? id) {
    _favouriteAdsList.remove(id);
    notifyListeners();
  }

  clearFavouriteAdsList() {
    _favouriteAdsList.clear();
    notifyListeners();
  }

  Map<String?, int?> get favouriteAdsList => _favouriteAdsList;

  Future<List<Ad>> getFavouriteAdsList() async {
    final response = await _apiProvider.get(Urls.FAVOURITE_URL +
        'user_id=${_currentUser!.userId}&page=1&api_lang=$_currentLang');
    List<Ad> adsList = <Ad>[];
    if (response['response'] == '1') {
      Iterable iterable = response['ads'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }
}
