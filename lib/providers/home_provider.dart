import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/models/blacklist.dart';
import 'package:auor/models/category.dart';
import 'package:auor/models/city.dart';
import 'package:auor/models/country.dart';
import 'package:auor/models/marka.dart';
import 'package:auor/models/model.dart';
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

  void updateSelectedCategory(CategoryModel? categoryModel) {
    _lastSelectedCategory!.isSelected = false;
    for (int i = 0; i < _categoryList.length; i++) {
      if (categoryModel!.catId == _categoryList[i]!.catId) {
        _lastSelectedCategory = _categoryList[i];
        _lastSelectedCategory!.isSelected = true;
      }
      notifyListeners();
    }
  }

  CategoryModel? get lastSelectedCategory => _lastSelectedCategory;

  Future<List<CategoryModel?>> getCategoryList(
      {CategoryModel? categoryModel,
      required bool enableSub,
      String? catId}) async {
    var response;
    if (enableSub) {
      response = await _apiProvider.get(Urls.MAIN_CATEGORY_URL +
          "?api_lang=$_currentLang" +
          "&cat_id=" +
          catId!);
    } else {
      response = await _apiProvider
          .get(Urls.MAIN_CATEGORY_URL + "?api_lang=$_currentLang");
    }

    if (response['response'] == '1') {
      Iterable iterable = response['cat'];
      _categoryList =
          iterable.map((model) => CategoryModel.fromJson(model)).toList();

      if (!_enableSearch) {
        _categoryList.insert(0, categoryModel);
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

  Future<List<CategoryModel?>> getCategoryList1(
      {CategoryModel? categoryModel,
      required bool enableSub,
      String? catId}) async {
    var response;
    if (enableSub) {
      response = await _apiProvider.get(
          "http://auor-app.com/api/getcat" +
              "?api_lang=$_currentLang" +
              "&cat_id=" +
              catId!);
    } else {
      response = await _apiProvider.get(
          "http://auor-app.com/api/getcat" +
              "?api_lang=$_currentLang");
    }

    if (response['response'] == '1') {
      Iterable iterable = response['cat'];
      _categoryList =
          iterable.map((model) => CategoryModel.fromJson(model)).toList();
    }
    return _categoryList;
  }

  Future<List<CategoryModel?>> getCategoryList2(
      {CategoryModel? categoryModel,
      required bool enableSub,
      String? catId}) async {
    var response;
    if (enableSub) {
      response = await _apiProvider.get(
          "http://auor-app.com/api/getcat1" +
              "?api_lang=$_currentLang" +
              "&cat_id=" +
              catId!);
    } else {
      response = await _apiProvider.get(
          "http://auor-app.com/api/getcat1" +
              "?api_lang=$_currentLang");
    }

    if (response['response'] == '1') {
      Iterable iterable = response['cat'];
      _categoryList =
          iterable.map((model) => CategoryModel.fromJson(model)).toList();
    }
    return _categoryList;
  }

  Future<List<CategoryModel>> getSubList(
      {required bool enableSub, String? catId}) async {
    var response;
    if (enableSub) {
      response = await _apiProvider.get(Urls.MAIN_CATEGORY_URL +
          "?api_lang=$_currentLang" +
          "&cat_id=$catId");
    } else {
      response = await _apiProvider
          .get(Urls.MAIN_CATEGORY_URL + "?api_lang=$_currentLang");
    }

    List subList = <CategoryModel>[];
    if (response['response'] == '1') {
      Iterable iterable = response['cat'];
      subList = iterable.map((model) => CategoryModel.fromJson(model)).toList();
    }
    return subList as FutureOr<List<CategoryModel>>;
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

  Future<List<Marka>> getMarkaList() async {
    final response =
        await _apiProvider.get(Urls.GET_MARKA_URL + "?api_lang=$_currentLang");
    List<Marka> markaList = <Marka>[];
    if (response['response'] == '1') {
      Iterable iterable = response['marka'];
      markaList = iterable.map((model) => Marka.fromJson(model)).toList();
    }
    return markaList;
  }

  Future<List<Model>> getModelList() async {
    final response =
        await _apiProvider.get(Urls.GET_MODEL_URL + "?api_lang=$_currentLang");
    List<Model> modelList = <Model>[];
    if (response['response'] == '1') {
      Iterable iterable = response['model'];
      modelList = iterable.map((model) => Model.fromJson(model)).toList();
    }
    return modelList;
  }

  Future<List<Ad>> getAdsList(int offset, int limit) async {
    final response = await _apiProvider
        .post(Urls.SEARCH_URL123 + "?api_lang=$_currentLang&limit=$limit&offset=$offset", body: {
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


  Future<List<Ad>> getAdsList111() async {
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

  Future<List<Ad>> getAdsSearchList(int offset, int limit) async {
    final response = await _apiProvider
        .post(Urls.SEARCH_URL123 + "?api_lang=$_currentLang&limit=$limit&offset=$offset", body: {
      "ads_title": _searchKey,
      "priceFrom": _priceFrom,
      "priceTo": _priceTo,
      "ads_rooms": _rooms,
      "ads_cat":
          _lastSelectedCategory != null ? _lastSelectedCategory!.catId : '0',
      "ads_sub": _selectedSub != null ? _selectedSub!.catId : '0',
      "ads_city": _selectedCity != null ? _selectedCity!.cityId : '0',
      "ads_marka": _selectedMarka != null ? _selectedMarka!.markaId : '0',
      "ads_model": _selectedModel != null ? _selectedModel!.modelId : '0',
      "fav_user_id": _currentUser == null ? '' : _currentUser!.userId
    });

    List<Ad> adsList = <Ad>[];
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  Future<List<Ad>> getAdsSearchList111() async {
    final response = await _apiProvider
        .post(Urls.SEARCH_URL + "?api_lang=$_currentLang", body: {
      "ads_title": _searchKey,
      "priceFrom": _priceFrom,
      "priceTo": _priceTo,
      "ads_rooms": _rooms,
      "ads_cat":
      _lastSelectedCategory != null ? _lastSelectedCategory!.catId : '0',
      "ads_sub": _selectedSub != null ? _selectedSub!.catId : '0',
      "ads_city": _selectedCity != null ? _selectedCity!.cityId : '0',
      "ads_marka": _selectedMarka != null ? _selectedMarka!.markaId : '0',
      "ads_model": _selectedModel != null ? _selectedModel!.modelId : '0',
      "fav_user_id": _currentUser == null ? '' : _currentUser!.userId
    });

    List<Ad> adsList = <Ad>[];
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  Future<List<Blacklist>> getBlacklist(String tt) async {
    final response =
        await _apiProvider.post(Urls.BLACKLIST_URL, body: {"s_value": tt});

    List<Blacklist> adsList = <Blacklist>[];
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Blacklist.fromJson(model)).toList();
    }
    return adsList;
  }

  String? _searchKey = '';

  void setSearchKey(String? searchKey) {
    _searchKey = searchKey;
    notifyListeners();
  }

  String? get searchKey => _searchKey;

  String _catName = '';

  void setCatName(String catName) {
    _catName = catName;
    notifyListeners();
  }

  String get catName => _catName;

  String? _omarKey = '';

  void setOmarKey(String? omarKey) {
    _omarKey = omarKey;
    notifyListeners();
  }

  String? get omarKey => _omarKey;

  String _checkedValue = '';

  void setCheckedValue(String checkedValue) {
    _checkedValue = checkedValue;
    notifyListeners();
  }

  String get checkedValue => _checkedValue;

  String _searchKeyBlacklist = '';

  void setSearchKeyBlacklist(String searchKeyBlacklist) {
    _searchKeyBlacklist = searchKeyBlacklist;
    notifyListeners();
  }

  String get searchKeyBlacklist => _searchKeyBlacklist;

  String _priceFrom = '';

  void setPriceFrom(String priceFrom) {
    _priceFrom = priceFrom;
    notifyListeners();
  }

  String get priceFrom => _priceFrom;

  String _priceTo = '';

  void setPriceTo(String priceTo) {
    _priceTo = priceTo;
    notifyListeners();
  }

  String get priceTo => _priceTo;

  String _rooms = '';

  void setRooms(String rooms) {
    _rooms = rooms;
    notifyListeners();
  }

  String get rooms => _rooms;

  Country? _selectedCountry;

  void setSelectedCountry(Country? country) {
    _selectedCountry = country;
    notifyListeners();
  }

  Country? get selectedCountry => _selectedCountry;

  Marka? _selectedMarka;

  void setSelectedMarka(Marka? marka) {
    _selectedMarka = marka;
    notifyListeners();
  }

  Marka? get selectedMarka => _selectedMarka;

  Model? _selectedModel;

  void setSelectedModel(Model? model) {
    _selectedModel = model;
    notifyListeners();
  }

  Model? get selectedModel => _selectedModel;

  CategoryModel? _selectedSub;

  void setSelectedSub(CategoryModel? sub) {
    _selectedSub = sub;
    notifyListeners();
  }

  CategoryModel? get selectedSub => _selectedSub;

  CategoryModel? _selectedCat;

  void setSelectedCat(CategoryModel? Cat) {
    _selectedCat = Cat;
    notifyListeners();
  }

  CategoryModel? get selectedCat => _selectedCat;

  String? _currentAds = '';

  void setCurrentAds(String? currentAds) {
    _currentAds = currentAds;
    notifyListeners();
  }

  String? get currentAds => _currentAds;

  // current seller
  String? _currentSeller = '';

  void setCurrentSeller(String? currentSeller) {
    _currentSeller = currentSeller;
    notifyListeners();
  }

  String? get currentSeller => _currentSeller;

  // current seller Name
  String? _currentSellerName = '';

  void setCurrentSellerName(String? currentSellerName) {
    _currentSellerName = currentSellerName;
    notifyListeners();
  }

  String? get currentSellerName => _currentSellerName;

  // current seller Phone
  String? _currentSellerPhone = '';

  void setCurrentSellerPhone(String? currentSellerPhone) {
    _currentSellerPhone = currentSellerPhone;
    notifyListeners();
  }

  String? get currentSellerPhone => _currentSellerPhone;

  // current seller Photo
  String? _currentSellerPhoto = '';

  void setCurrentSellerPhoto(String? currentSellerPhoto) {
    _currentSellerPhoto = currentSellerPhoto;
    notifyListeners();
  }

  String? get currentSellerPhoto => _currentSellerPhoto;

  City? _selectedCity;

  void setSelectedCity(City? city) {
    _selectedCity = city;
    notifyListeners();
  }

  City? get selectedCity => _selectedCity;

  String? _age = '';

  void setAge(String? age) {
    _age = age;
    notifyListeners();
  }

  String? get age => _age;

  String _selectedGender = '';

  void setSelectedGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  String get selectedGender => _selectedGender;

  String _checkedValue1 = '';

  void setCheckedValue1(String checkedValue) {
    _checkedValue1 = checkedValue;
    notifyListeners();
  }

  String get checkedValue1 => _checkedValue1;

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

  // current seller Name

  // current seller Phone

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
    final response =
        await _apiProvider.get("http://auor-app.com/api/social");
    String? messages = '';
    if (response['response'] == '1') {
      messages = response['setting_omar'];
    }
    return messages;
  }

  Future<String?> getAli(String? adsId, String? userId) async {
    final response = await _apiProvider.get(
        "http://auor-app.com/api/check_commition_pay?ads_id=$adsId&user_id=$userId");
    String? messages = response['response'];

    return messages;
  }

  Future<List<Ad>> getAdsListNext($adsId, $adsCat) async {
    final response = await _apiProvider
        .post("http://auor-app.com/api/next_ads", body: {
      "ads_id": $adsId,
      "ads_cat": $adsCat,
    });
    List<Ad> adsList = <Ad>[];
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  Future<List<Ad>> getAdsListPrev($adsId, $adsCat) async {
    final response = await _apiProvider
        .post("http://auor-app.com/api/prev_ads", body: {
      "ads_id": $adsId,
      "ads_cat": $adsCat,
    });
    List<Ad> adsList = <Ad>[];
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  Future<List<Ad>> getAdsListCurrent($adsId) async {
    final response = await _apiProvider
        .post("http://auor-app.com/api/current_ads", body: {
      "ads_id": $adsId,
    });
    List<Ad> adsList = <Ad>[];
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  Ad? _selectedEditAd;

  void setSelectedEditAd(Ad? ad) {
    _selectedEditAd = ad;
    notifyListeners();
  }

  Ad? get selectedEditAd => _selectedEditAd;
}
