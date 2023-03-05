import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/custom_widgets/buttons/custom_button.dart';
import 'package:auor/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:auor/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:auor/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/models/category.dart';
import 'package:auor/models/city.dart';
import 'package:auor/models/slider.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/providers/navigation_provider.dart';
import 'package:auor/ui/my_ads/my_ads_screen.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/commons.dart';
import 'package:auor/utils/urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;
import 'dart:math' as math;

class EditAdScreen extends StatefulWidget {
  final Ad? ad;

  const EditAdScreen({Key? key, this.ad}) : super(key: key);

  @override
  _EditAdScreenState createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditAdScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  Future<List<City>>? _cityList;
  Future<List<CategoryModel?>>? _categoryList;
  City? _selectedCity;
  CategoryModel? _selectedCategory;
  bool _initialRun = true;
  late HomeProvider _homeProvider;
  late List<String?> _genders;
  Future<List<SliderModel>>? _sliderImages;
  String? _selectedGender;
  File? _imageFile;
  dynamic _pickImageError;
  final _picker = ImagePicker();
  late AuthProvider _authProvider;
  ApiProvider _apiProvider = ApiProvider();
  bool _isLoading = false;
  String? _adsTitle = '', _adsPrice = '', _adsDescription = '';
  bool _initSelectedCity = true,
      _initSelectedCategory = true,
      _initSelectedKind = true;
  LocationData? _locData;

  Future<List<SliderModel>> _getsliderImages() async {
    Map<String, dynamic> results = await (_apiProvider
        .get(Urls.SLIDER_URL1 + "ads_id=" + widget.ad!.adsId!));
    List sliderList = <SliderModel>[];
    if (results['response'] == '1') {
      Iterable iterable = results['slider'];
      sliderList =
          iterable.map((model) => SliderModel.fromJson(model)).toList();
    } else {
      print('error');
    }
    print("testSliders ${sliderList.length}");
    return sliderList as FutureOr<List<SliderModel>>;
  }

  Future<void> _getCurrentUserLocation() async {
    _locData = await Location().getLocation();
    if (_locData != null) {
      Commons.showToast(context,
          message: AppLocalizations.of(context)!.translate('detect_location')!);
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.subject),
                    title: new Text('Gallery'),
                    onTap: () {
                      _onImageButtonPressed(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      await (_picker.pickImage(source: source)).then((value) async {
        if (value != null) {
          setState(() => _isLoading = true);
          final pickedFile = value;
          _imageFile = File(pickedFile.path);
          FormData formData;

          String fileName =
              (_imageFile != null) ? Path.basename(_imageFile!.path) : "";
          formData = new FormData.fromMap({
            "ads_id": widget.ad!.adsId,
            "imgURL": (_imageFile != null)
                ? await MultipartFile.fromFile(_imageFile!.path,
                    filename: fileName)
                : "",
          });

          final results = await _apiProvider.postWithDio(
              "http://auor-app.com/api/add_ads_upload" +
                  "?api_lang=${_authProvider.currentLang}",
              body: formData);
          setState(() {
            _isLoading = false;
            _sliderImages = _getsliderImages();
          });

          if (results['response'] == "1") {
            Commons.showToast(context!, message: "تم اضافة الصورة");
            // Navigator.push(
            //     context!,
            //     MaterialPageRoute(
            //         builder: (context) => MyAdsScreen()));
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => EditAdScreen(
            //           ad: _homeProvider.selectedEditAd,
            //
            //
            //         )));

          } else {
            Commons.showError(context!, results["message"]);
          }

          setState(() {});
        }
      });
    } catch (e) {
      _pickImageError = e;
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sliderImages = _getsliderImages();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _genders = [
        AppLocalizations.of(context)!.translate('male'),
        AppLocalizations.of(context)!.translate('female'),
        AppLocalizations.of(context)!.translate('undefined')
      ];
      _homeProvider = Provider.of<HomeProvider>(context);
      _categoryList = _homeProvider.getCategoryList1(
          categoryModel: CategoryModel(isSelected: false), enableSub: false);
      _cityList = _homeProvider.getCityList(enableCountry: false);
      _adsTitle = widget.ad!.adsTitle;
      _adsPrice = widget.ad!.adsPrice;
      _adsDescription = widget.ad!.adsDetails;
      _sliderImages = _getsliderImages();
      _initialRun = false;
      setState(() {});
    }
  }

  Widget _buildBodyItem() {
    var genders = _genders.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item!),
        value: item,
      );
    }).toList();

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(25, 5, 25, 10),
              child: Text(_homeProvider.currentLang == 'ar'
                  ? "صور الاعلان"
                  : "Ad photos"),
            ),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(25, 5, 5, 10)),
                GestureDetector(
                    onTap: () {
                      _settingModalBottomSheet(context);
                    },
                    child: Container(
                      height: _height * 0.1,
                      width: _width * .20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        border: Border.all(
                          color: hintColor.withOpacity(0.4),
                        ),
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/newadd.png'),
                        ],
                      ),
                    )),
              ],
            ),
            Padding(padding: EdgeInsets.all(5)),
            Container(
              height: _height * .17,
              width: _width,
              padding: EdgeInsets.only(right: _width * .04, left: _width * .02),
              child: FutureBuilder<List<SliderModel>>(
                  future: _sliderImages,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return SpinKitFadingCircle(color: mainAppColor);
                      case ConnectionState.active:
                        return Text('');
                      case ConnectionState.waiting:
                        return SpinKitFadingCircle(color: mainAppColor);
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text('');
                        } else {
                          if (snapshot.data!.length > 0) {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(left: _width * .02),
                                    height: _height * 0.15,
                                    width: _width * .20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      border: Border.all(
                                        color: hintColor.withOpacity(0.4),
                                      ),
                                      color: Colors.grey[100],
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              snapshot.data![index].photo!,
                                              height: _width * .23,
                                            )),
                                        GestureDetector(
                                          child: Text("حذف"),
                                          onTap: () async {
                                            final results = await _apiProvider.post(
                                                "http://auor-app.com/api/do_delete_photo" +
                                                    "?id=${snapshot.data![index].photo}&api_lang=${_authProvider.currentLang}");

                                            if (results['response'] == "1") {
                                              Commons.showToast(context,
                                                  message: results["message"]);
                                            } else {
                                              Commons.showError(
                                                  context, results["message"]);
                                            }

                                            setState(() {
                                              _sliderImages =
                                                  _getsliderImages();
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            return Text("لا يوجد صور مضافة");
                          }
                        }
                    }
                    return SpinKitFadingCircle(color: mainAppColor);
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
                initialValue: _adsTitle,
                hintTxt: AppLocalizations.of(context)!.translate('ad_title'),
                onChangedFunc: (text) {
                  _adsTitle = text;
                },
                validationFunc: validateAdTitle,
              ),
            ),
            FutureBuilder<List<CategoryModel?>>(
              future: _categoryList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasData) {
                    var categoryList = snapshot.data!.map((item) {
                      return new DropdownMenuItem<CategoryModel>(
                        child: new Text(item!.catName!),
                        value: item,
                      );
                    }).toList();
                    if (_initSelectedCategory) {
                      for (int i = 0; i < snapshot.data!.length; i++) {
                        if (widget.ad!.adsCatName ==
                            snapshot.data![i]!.catName) {
                          _selectedCategory = snapshot.data![i];
                          break;
                        }
                      }
                      _initSelectedCategory = false;
                    }

                    return DropDownListSelector(
                      dropDownList: categoryList,
                      hint: AppLocalizations.of(context)!
                          .translate('choose_category'),
                      onChangeFunc: (newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      value: _selectedCategory,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
                initialValue: _adsPrice,
                hintTxt: AppLocalizations.of(context)!.translate('ad_price'),
                onChangedFunc: (text) {
                  _adsPrice = text;
                },
                validationFunc: validateAdTitle,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
            ),
            FutureBuilder<List<City>>(
              future: _cityList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var cityList = snapshot.data!.map((item) {
                    return new DropdownMenuItem<City>(
                      child: new Text(item.cityName!),
                      value: item,
                    );
                  }).toList();

                  if (_initSelectedCity) {
                    for (int i = 0; i < snapshot.data!.length; i++) {
                      if (widget.ad!.adsCityName ==
                          snapshot.data![i].cityName) {
                        _selectedCity = snapshot.data![i];
                        break;
                      }
                    }
                    _initSelectedCity = false;
                  }
                  return DropDownListSelector(
                    dropDownList: cityList,
                    hint:
                        AppLocalizations.of(context)!.translate('choose_city'),
                    onChangeFunc: (newValue) {
                      setState(() {
                        _selectedCity = newValue;
                      });
                    },
                    value: _selectedCity,
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
                initialValue: _adsDescription,
                maxLines: 3,
                hintTxt:
                    AppLocalizations.of(context)!.translate('ad_description'),
                validationFunc: validateAdDescription,
                onChangedFunc: (text) {
                  _adsDescription = text;
                },
              ),
            ),
            CustomButton(
              btnLbl: AppLocalizations.of(context)!.translate('save_edit'),
              btnColor: mainAppColor,
              onPressedFunction: () async {
                if (_formKey.currentState!.validate() &
                    checkEditAdValidation(context,
                        adMainCategory: _selectedCategory,
                        adCity: _selectedCity,
                        adKind: _selectedGender)) {
                  setState(() => _isLoading = true);
                  FormData formData;
                  if (_imageFile != null) {
                    String fileName = Path.basename(_imageFile!.path);
                    formData = new FormData.fromMap({
                      "ad_id": widget.ad!.adsId,
                      "user_id": _authProvider.currentUser!.userId,
                      "ads_title": _adsTitle,
                      "ads_details": _adsDescription,
                      "ads_cat": _selectedCategory!.catId,
                      // 'ads_gender': _selectedGender,
                      "ads_city": _selectedCity!.cityId,
                      "ads_price": _adsPrice,
                      "ads_location":
                          '${_locData!.latitude},${_locData!.longitude}',
                      "imgURL[0]": await MultipartFile.fromFile(
                          _imageFile!.path,
                          filename: fileName),
                    });
                  } else {
                    formData = new FormData.fromMap({
                      "ad_id": widget.ad!.adsId,
                      "user_id": _authProvider.currentUser!.userId,
                      "ads_title": _adsTitle,
                      "ads_details": _adsDescription,
                      "ads_cat": _selectedCategory!.catId,
                      // 'ads_gender': _selectedGender,
                      "ads_city": _selectedCity!.cityId,
                      "ads_price": _adsPrice,
                      // "ads_location":'${_locData.latitude},${_locData.longitude}',
                    });
                  }
                  print(formData.files.toString());
                  final results = await _apiProvider.postWithDio(
                      Urls.EDIT_AD_URL +
                          "?api_lang=${_authProvider.currentLang}",
                      body: formData);
                  setState(() => _isLoading = false);

                  if (results['response'] == "1") {
                    Commons.showToast(context, message: results["message"]);

                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/my_ads_screen');
                  } else {
                    Commons.showError(context, results["message"]);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    return PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),
          Container(
              height: 60,
              decoration: BoxDecoration(
                color: mainAppColor,
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return authProvider.currentLang == 'ar'
                            ? Image.asset(
                                'assets/images/back.png',
                              )
                            : Transform.rotate(
                                angle: 180 * math.pi / 180,
                                child: Image.asset(
                                  'assets/images/back.png',
                                ));
                      },
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Text(AppLocalizations.of(context)!.translate('ad_edit')!,
                      style: Theme.of(context).textTheme.headline1),
                  Spacer(
                    flex: 3,
                  ),
                ],
              )),
          _isLoading
              ? Center(
                  child: SpinKitFadingCircle(color: mainAppColor),
                )
              : Container()
        ],
      )),
    );
  }
}
