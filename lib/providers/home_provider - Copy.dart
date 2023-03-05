import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/models/category.dart';
import 'package:auor/models/city.dart';
import 'package:auor/models/country.dart';
import 'package:auor/models/user.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/utils/urls.dart';

class HomeProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  User? _currentUser;

  String? _currentLang;

  void update(AuthProvider authProvider) {
    _currentUser = authProvider.currentUser;
    _currentLang = authProvider.currentLang;
  }

  String? get currentLang => _currentLang;

  bool _enableSearch = false;

  void setEnableSearch(bool enableSearch) {
    _enableSearch = enableSearch;
    notifyListeners();
  }

  bool get enableSearch => _enableSearch;

  List<CategoryModel?> _categoryList = <CategoryModel?>[];

  List<CategoryModel?> get categoryList => _categoryList;

  CategoryModel? _lastSelectedCategory;

  void updateChangesOnCategoriesList(int index) {
    if (lastSelectedCategory != null) {
      _lastSelectedCategory!.isSelected = false;
    }
    _categoryList[index]!.isSelected = true;
    _lastSelectedCategory = _categoryList[index];
    notifyListeners();
  }

  void updateSelectedCategory(CategoryModel categoryModel) {
    _lastSelectedCategory!.isSelected = false;
    for (int i = 0; i < _categoryList.length; i++) {
      if (categoryModel.catId == _categoryList[i]!.catId) {
        _lastSelectedCategory = _categoryList[i];
        _lastSelectedCategory!.isSelected = true;
      }
      notifyListeners();
    }
  }

  CategoryModel? get lastSelectedCategory => _lastSelectedCategory;

  Future<List<CategoryModel?>> getCategoryList(
      {CategoryModel? categoryModel}) async {
    final response = await _apiProvider
        .get(Urls.MAIN_CATEGORY_URL + "?api_lang=$_currentLang");

    if (response['response'] == '1') {
      Iterable iterable = response['cat'];
      _categoryList =
          iterable.map((model) => CategoryModel.fromJson(model)).toList();

      if (!_enableSearch) {
        _lastSelectedCategory = _categoryList[0];
      } else {
        categoryModel!.isSelected = false;
        _categoryList.insert(0, categoryModel);
        for (int i = 0; i < _categoryList.length; i++) {
          if (lastSelectedCategory!.catId == _categoryList[i]!.catId) {
            _categoryList[i]!.isSelected = true;
          }
        }
      }
    }
    return _categoryList;
  }

  Future<List<City>> getCityList(
      {required bool enableCountry, String? countryId}) async {
    var response;
    if (enableCountry) {
      response = await _apiProvider.get(Urls.CITIES_URL +
          "?api_lang=$_currentLang" +
          "&country_id=$countryId");
    } else {
      response =
          await _apiProvider.get(Urls.CITIES_URL + "?api_lang=$_currentLang");
    }

    List cityList = <City>[];
    if (response['response'] == '1') {
      Iterable iterable = response['city'];
      cityList = iterable.map((model) => City.fromJson(model)).toList();
    }
    return cityList as FutureOr<List<City>>;
  }

  Future<List<Country>> getCountryList() async {
    final response = await _apiProvider
        .get(Urls.GET_COUNTRY_URL + "?api_lang=$_currentLang");
    List<Country> countryList = <Country>[];
    if (response['response'] == '1') {
      Iterable iterable = response['country'];
      countryList = iterable.map((model) => Country.fromJson(model)).toList();
    }
    return countryList;
  }

  Future<List<Ad>> getAdsList() async {
    final response = await _apiProvider
        .post(Urls.SEARCH_URL + "?api_lang=$_currentLang", body: {
      "ads_cat":
          _lastSelectedCategory == null ? '0' : _lastSelectedCategory!.catId,
      "fav_user_id": _currentUser == null ? '' : _currentUser!.userId
    });
    List<Ad> adsList = <Ad>[];
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  Future<List<Ad>> getAdsSearchList() async {
    final response = await _apiProvider
        .post(Urls.SEARCH_URL + "?api_lang=$_currentLang", body: {
      "ads_title": _searchKey,
      "ads_cat": _lastSelectedCategory!.catId,
      "ads_country": _selectedCity != null ? _selectedCountry!.countryId : '',
      "ads_city": _selectedCity != null ? _selectedCity!.cityId : '',
      "ads_age": _age != null ? _age : '',
      "ads_gender": _selectedGender != null ? _selectedGender : '',
      "fav_user_id": _currentUser == null ? '' : _currentUser!.userId
    });

    List<Ad> adsList = <Ad>[];
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  String _searchKey = '';

  void setSearchKey(String searchKey) {
    _searchKey = searchKey;
    notifyListeners();
  }

  String get searchKey => _searchKey;

  Country? _selectedCountry;

  void setSelectedCountry(Country country) {
    _selectedCountry = country;
    notifyListeners();
  }

  Country? get selectedCountry => _selectedCountry;

  City? _selectedCity;

  void setSelectedCity(City city) {
    _selectedCity = city;
    notifyListeners();
  }

  String _currentAds = '';

  void setCurrentAds(String currentAds) {
    _currentAds = currentAds;
    notifyListeners();
  }

  String get currentAds => _currentAds;

  String? _selectedCategory1;

  void setSelectedCategory1(String category) {
    _selectedCategory1 = category;
    notifyListeners();
  }

  String? get selectedCategory1 => _selectedCategory1;

  String _age = '';

  void setAge(String age) {
    _age = age;
    notifyListeners();
  }

  String get age => _age;

  String _selectedGender = '';

  void setSelectedGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  String get selectedGender => _selectedGender;

  String _omarKey = '';

  void setOmarKey(String omarKey) {
    _omarKey = omarKey;
    notifyListeners();
  }

  String get omarKey => _omarKey;

  // current seller
  String _currentSeller = '';

  void setCurrentSeller(String currentSeller) {
    _currentSeller = currentSeller;
    notifyListeners();
  }

  String get currentSeller => _currentSeller;

  // current seller Name
  String _currentSellerName = '';

  void setCurrentSellerName(String currentSellerName) {
    _currentSellerName = currentSellerName;
    notifyListeners();
  }

  String get currentSellerName => _currentSellerName;

  // current seller Phone
  String _currentSellerPhone = '';

  void setCurrentSellerPhone(String currentSellerPhone) {
    _currentSellerPhone = currentSellerPhone;
    notifyListeners();
  }

  String get currentSellerPhone => _currentSellerPhone;

  // current seller whats
  String _currentSellerWhats = '';

  void setCurrentSellerWhats(String currentSellerWhats) {
    _currentSellerWhats = currentSellerWhats;
    notifyListeners();
  }

  String get currentSellerWhats => _currentSellerWhats;

  // current seller email
  String _currentSellerEmail = '';

  void setCurrentSellerEmail(String currentSellerEmail) {
    _currentSellerEmail = currentSellerEmail;
    notifyListeners();
  }

  String get currentSellerEmail => _currentSellerEmail;

  // current seller Photo
  String _currentSellerPhoto = '';

  void setCurrentSellerPhoto(String currentSellerPhoto) {
    _currentSellerPhoto = currentSellerPhoto;
    notifyListeners();
  }

  String get currentSellerPhoto => _currentSellerPhoto;

  Future<String?> getUnreadMessage() async {
    final response = await _apiProvider.get(
        "http://auor-app.com/api/get_unread_message?user_id=${_currentUser!.userId}");
    String? messages = '';
    if (response['response'] == '1') {
      messages = response['Number'];
    }
    return messages;
  }

  Future<String?> getUnreadNotify() async {
    final response = await _apiProvider.get(
        "http://auor-app.com/api/get_unread_notify?user_id=${_currentUser!.userId}");
    String? messages = '';
    if (response['response'] == '1') {
      messages = response['Number'];
    }
    return messages;
  }

  Future<String?> getOmar() async {
    final response = await _apiProvider.get("http://auor-app.com/api/social");
    String? messages = '';
    if (response['response'] == '1') {
      messages = response['setting_omar'];
    }
    return messages;
  }

  String _checkedValue1 = '';

  void setCheckedValue1(String checkedValue) {
    _checkedValue1 = checkedValue;
    notifyListeners();
  }

  String get checkedValue1 => _checkedValue1;

  String _searchKeyBlacklist = '';

  void setSearchKeyBlacklist(String searchKeyBlacklist) {
    _searchKeyBlacklist = searchKeyBlacklist;
    notifyListeners();
  }

  String get searchKeyBlacklist => _searchKeyBlacklist;

  Future<List<Ad>> getAdsListRelated($adsId) async {
    final response = await _apiProvider.post(Urls.RELATED_ADS, body: {
      "ads_id": $adsId,
    });
    List<Ad> adsList = <Ad>[];
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  String _checkedValue = '';

  void setCheckedValue(String checkedValue) {
    _checkedValue = checkedValue;
    notifyListeners();
  }

  String get checkedValue => _checkedValue;

  Future<List<User>> getBlacklist(String tt) async {
    final response =
        await _apiProvider.post(Urls.BLACKLIST_URL, body: {"s_value": tt});

    List<User> adsList = <User>[];
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => User.fromJson(model)).toList();
    }
    return adsList;
  }

  Future<List<Ad>> getBlacklist1(String tt) async {
    final response =
        await _apiProvider.post(Urls.BLACKLIST_URL1, body: {"s_value": tt});

    List<Ad> adsList = <Ad>[];
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  Future<List<Ad>> getFollowlist() async {
    final response = await _apiProvider.get(
        "http://auor-app.com/api/my_follow?user_id=${_currentUser!.userId}");
    String messages = '';

    List<Ad> adsList = <Ad>[];
    if (response['response'] == '1') {
      Iterable iterable = response['ads'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  Future<List<User>> getFollowlist2() async {
    final response = await _apiProvider.get(
        "http://auor-app.com/api/my_follow2?user_id=${_currentUser!.userId}");
    String messages = '';

    List<User> adsList = <User>[];
    if (response['response'] == '1') {
      Iterable iterable = response['ads'];
      adsList = iterable.map((model) => User.fromJson(model)).toList();
    }
    return adsList;
  }

  CategoryModel? _selectedCat;

  void setSelectedCat(CategoryModel Cat) {
    _selectedCat = Cat;
    notifyListeners();
  }

  CategoryModel? get selectedCat => _selectedCat;
}
