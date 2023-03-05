import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/custom_widgets/buttons/custom_button.dart';
import 'package:auor/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:auor/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:auor/custom_widgets/dialogs/confirmation_dialog.dart';
import 'package:auor/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/category.dart';
import 'package:auor/models/city.dart';
import 'package:auor/models/country.dart';
import 'package:auor/models/marka.dart';
import 'package:auor/models/model.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/providers/navigation_provider.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/commons.dart';
import 'package:auor/utils/urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';

class AddAdScreen extends StatefulWidget {
  @override
  _AddAdScreenState createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  Future<List<Country>>? _countryList;
  Future<List<City>>? _cityList;
  Future<List<CategoryModel?>>? _categoryList;
  Future<List<CategoryModel?>>? _subList;
  Country? _selectedCountry;
  City? _selectedCity;
  CategoryModel? _selectedCategory;
  CategoryModel? _selectedSub;
  bool _initialRun = true;
  late HomeProvider _homeProvider;
  List<String>? _genders;

  File? _imageFile;
  File? _imageFile1;
  File? _imageFile2;
  File? _imageFile3;
  File? _imageFile4;
  File? _imageFile5;
  File? _imageFile6;
  File? _imageFile7;
  File? _imageFile8;
  File? _imageFile9;
  String? _xx = null;

  bool? checkedValue = false;

  Future<List<Marka>>? _markaList;
  Marka? _selectedMarka;

  Future<List<Model>>? _modelList;
  Model? _selectedModel;

  dynamic _pickImageError;
  final _picker = ImagePicker();
  late AuthProvider _authProvider;
  ApiProvider _apiProvider = ApiProvider();
  bool _isLoading = false;
  String _adsTitle = '';
  String _adsVideo = '';
  String _adsPrice = '';
  String _adsPhone = '';
  String _adsWhatsapp = '';
  String _adsDescription = '';
  String _adsRooms = '';
  String _adsOutColor = '';
  String _adsFuel = '';
  String _adsCylinders = '';
  String _adsSpeedometer = '';
  String _adsInColor = '';
  String _adsChairsType = '';
  late NavigationProvider _navigationProvider;
  LocationData? _locData;

  late List<String> _adsPropulsion;
  String? _selectedAdsPropulsion;
  final imagesBytes = {};
  late List<String> _adsOpenRoof;
  String? _selectedAdsOpenRoof;

  late List<String> _adsGps;
  String? _selectedAdsGps;

  late List<String> _adsBluetooth;
  String? _selectedAdsBluetooth;

  late List<String> _adsCd;
  String? _selectedAdsCd;

  late List<String> _adsDvd;
  String? _selectedAdsDvd;

  late List<String> _adsSensors;
  String? _selectedAdsSensors;

  late List<String> _adsGuarantee;
  String? _selectedAdsGuarantee;

  late List<String> _adsCamera;
  String? _selectedAdsCamera;

  late List<String> _adsGear;
  String? _selectedAdsGear;

  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';

  Future<void> _getCurrentUserLocation() async {
    _locData = await Location().getLocation();
    if (_locData != null) {
      print('lat' + _locData!.latitude.toString());
      print('longitude' + _locData!.longitude.toString());
      Commons.showToast(context,
          message: AppLocalizations.of(context)!.translate('detect_location')!);
      setState(() {});
    }
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile =
          await (_picker.getImage(source: source) as FutureOr<PickedFile>);
      _imageFile = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  void _onImageButtonPressed1(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile =
          await (_picker.getImage(source: source) as FutureOr<PickedFile>);
      _imageFile1 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  void _onImageButtonPressed2(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile =
          await (_picker.getImage(source: source) as FutureOr<PickedFile>);
      _imageFile2 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  void _onImageButtonPressed3(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile =
          await (_picker.getImage(source: source) as FutureOr<PickedFile>);
      _imageFile3 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  void _onImageButtonPressed4(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile =
          await (_picker.getImage(source: source) as FutureOr<PickedFile>);
      _imageFile4 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  void _onImageButtonPressed5(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile =
          await (_picker.getImage(source: source) as FutureOr<PickedFile>);
      _imageFile5 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  void _onImageButtonPressed6(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile =
          await (_picker.getImage(source: source) as FutureOr<PickedFile>);
      _imageFile6 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  void _onImageButtonPressed7(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile =
          await (_picker.getImage(source: source) as FutureOr<PickedFile>);
      _imageFile7 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  void _onImageButtonPressed8(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile =
          await (_picker.getImage(source: source) as FutureOr<PickedFile>);
      _imageFile8 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  void _onImageButtonPressed9(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile =
          await (_picker.getImage(source: source) as FutureOr<PickedFile>);
      _imageFile9 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 4,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 200,
          height: 200,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 12,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Auor App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);
      _adsPropulsion = ["دفع امامي", "دفع خلفي"];

      _adsOpenRoof = ["نعم", "لا"];
      _adsGps = ["نعم", "لا"];
      _adsBluetooth = ["نعم", "لا"];
      _adsCd = ["نعم", "لا"];
      _adsDvd = ["نعم", "لا"];
      _adsSensors = ["نعم", "لا"];
      _adsGuarantee = ["نعم", "لا"];
      _adsCamera = ["نعم", "لا"];
      _adsGear = _homeProvider.currentLang == "ar"
          ? ["يدوي", "اتوماتك"]
          : ["manual", "automatic"];

      _categoryList = _homeProvider.getCategoryList(
          categoryModel: CategoryModel(
              isSelected: false,
              catId: '0',
              catName: AppLocalizations.of(context)!.translate('total'),
              catImage: 'assets/images/all.png'),
          enableSub: false);

      _subList = _homeProvider.getCategoryList(
          categoryModel: CategoryModel(
              isSelected: false,
              catId: '0',
              catName: AppLocalizations.of(context)!.translate('all'),
              catImage: 'assets/images/all.png'),
          enableSub: true,
          catId: '66666');

      _countryList = _homeProvider.getCountryList();
      _cityList =
          _homeProvider.getCityList(enableCountry: true, countryId: '500');
      _markaList = _homeProvider.getMarkaList();
      _modelList = _homeProvider.getModelList();

      _initialRun = false;
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

  void _settingModalBottomSheet1(context) {
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
                      _onImageButtonPressed1(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed1(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  void _settingModalBottomSheet2(context) {
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
                      _onImageButtonPressed2(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed2(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  void _settingModalBottomSheet3(context) {
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
                      _onImageButtonPressed3(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed3(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  void _settingModalBottomSheet4(context) {
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
                      _onImageButtonPressed4(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed4(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  void _settingModalBottomSheet5(context) {
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
                      _onImageButtonPressed5(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed5(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  void _settingModalBottomSheet6(context) {
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
                      _onImageButtonPressed6(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed6(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  void _settingModalBottomSheet7(context) {
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
                      _onImageButtonPressed7(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed7(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  void _settingModalBottomSheet8(context) {
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
                      _onImageButtonPressed8(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed8(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  void _settingModalBottomSheet9(context) {
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
                      _onImageButtonPressed9(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed9(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  Widget _buildBodyItem() {
    var adsPropulsion = _adsPropulsion.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    var adsOpenRoof = _adsOpenRoof.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    var adsGps = _adsGps.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    var adsBluetooth = _adsBluetooth.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    var adsCd = _adsCd.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    var adsDvd = _adsDvd.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    var adsSensors = _adsSensors.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    var adsGuarantee = _adsGuarantee.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    var adsCamera = _adsCamera.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    var adsGear = _adsGear.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
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
            Container(
              height: images.length > 0 ? 200 : 75,
              child: Column(
                children: <Widget>[
                  // Center(child: Text('Error: $_error')),
                  CustomButton(
                    btnLbl: _homeProvider.currentLang == "ar"
                        ? "اختار صور الاعلان"
                        : "Pick images",
                    onPressedFunction: loadAssets,
                    btnColor: orangeColor,
                  ),

                  Expanded(
                    child: buildGridView(),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
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
                    categoryList.removeAt(0);
                    return DropDownListSelector(
                      dropDownList: categoryList,
                      hint: _homeProvider.currentLang == 'ar'
                          ? 'القسم الرئيسي'
                          : 'Main category',
                      onChangeFunc: (newValue) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          _selectedCategory = newValue;
                          _selectedSub = null;
                          _homeProvider.setSelectedCat(newValue);
                          _subList = _homeProvider.getCategoryList(
                              categoryModel: CategoryModel(
                                  isSelected: false,
                                  catId: '0',
                                  catName: AppLocalizations.of(context)!
                                      .translate('all'),
                                  catImage: 'assets/images/all.png'),
                              enableSub: true,
                              catId: _homeProvider.selectedCat!.catId);

                          _xx = _homeProvider.selectedCat!.catId;
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
              margin: EdgeInsets.only(top: _height * 0.02),
            ),
            FutureBuilder<List<CategoryModel?>>(
              future: _subList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasData) {
                    var categoryList = snapshot.data!.map((item) {
                      return new DropdownMenuItem<CategoryModel>(
                        child: new Text(item!.catName!),
                        value: item,
                      );
                    }).toList();
                    categoryList.removeAt(0);
                    return DropDownListSelector(
                      dropDownList: categoryList,
                      hint: _homeProvider.currentLang == 'ar'
                          ? 'القسم الفرعي'
                          : 'Sub category',
                      onChangeFunc: (newValue) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          _selectedSub = newValue;
                        });
                      },
                      value: _selectedSub,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                } else if (snapshot.hasError) {
                  DioError error = snapshot.error as DioError;
                  String message = error.message;
                  if (error.type == DioErrorType.connectTimeout)
                    message = 'Connection Timeout';
                  else if (error.type == DioErrorType.receiveTimeout)
                    message = 'Receive Timeout';
                  else if (error.type == DioErrorType.response)
                    message =
                        '404 server not found ${error.response!.statusCode}';
                  print(message);
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
            Container(
              margin:
                  EdgeInsets.only(top: _height * 0.02, bottom: _height * 0.01),
            ),
            Container(
              child: CustomTextFormField(
                hintTxt: AppLocalizations.of(context)!.translate('ad_price'),
                onChangedFunc: (text) {
                  _adsPrice = text;
                },
                inputData: TextInputType.number,
                validationFunc: validateAdPrice,
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: _height * 0.02, bottom: _height * 0.01),
            ),
            Container(
              child: CustomTextFormField(
                hintTxt:
                    _homeProvider.currentLang == "ar" ? "رقم الجوال" : "Phone",
                onChangedFunc: (text) {
                  _adsPhone = text;
                },
                inputData: TextInputType.number,
                validationFunc: validateUserPhone,
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: _height * 0.02, bottom: _height * 0.01),
            ),
            Container(
              child: CustomTextFormField(
                hintTxt: _homeProvider.currentLang == "ar"
                    ? "رقم الواتساب"
                    : "Whatsapp",
                onChangedFunc: (text) {
                  _adsWhatsapp = text;
                },
                inputData: TextInputType.number,
                validationFunc: validateUserPhone,
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: _height * 0.01, bottom: _height * 0.01),
            ),







            Container(
              margin:
                  EdgeInsets.only(top: _height * 0.01, bottom: _height * 0.01),
            ),
            FutureBuilder<List<Country>>(
              future: _countryList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasData) {
                    var countryList = snapshot.data!.map((item) {
                      return new DropdownMenuItem<Country>(
                        child: new Text(item.countryName!),
                        value: item,
                      );
                    }).toList();
                    return DropDownListSelector(
                      dropDownList: countryList,
                      hint: AppLocalizations.of(context)!
                          .translate('choose_country'),
                      onChangeFunc: (newValue) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          _selectedCountry = newValue;
                          _selectedCity = null;
                          _homeProvider.setSelectedCountry(newValue);
                          _cityList = _homeProvider.getCityList(
                              enableCountry: true,
                              countryId:
                                  _homeProvider.selectedCountry!.countryId);
                        });
                      },
                      value: _selectedCountry,
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
              margin: EdgeInsets.only(top: _height * 0.01),
            ),
            FutureBuilder<List<City>>(
              future: _cityList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasData) {
                    var cityList = snapshot.data!.map((item) {
                      return new DropdownMenuItem<City>(
                        child: new Text(item.cityName!),
                        value: item,
                      );
                    }).toList();
                    return DropDownListSelector(
                      dropDownList: cityList,
                      hint: AppLocalizations.of(context)!
                          .translate('choose_city'),
                      onChangeFunc: (newValue) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          _selectedCity = newValue;
                        });
                      },
                      value: _selectedCity,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                } else if (snapshot.hasError) {
                  DioError error = snapshot.error as DioError;
                  String message = error.message;
                  if (error.type == DioErrorType.connectTimeout)
                    message = 'Connection Timeout';
                  else if (error.type == DioErrorType.receiveTimeout)
                    message = 'Receive Timeout';
                  else if (error.type == DioErrorType.response)
                    message =
                        '404 server not found ${error.response!.statusCode}';
                  print(message);
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
                maxLines: 3,
                hintTxt:
                    AppLocalizations.of(context)!.translate('ad_description'),
                validationFunc: validateAdDescription,
                onChangedFunc: (text) {
                  _adsDescription = text;
                },
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: CheckboxListTile(
                checkColor: Colors.white,
                activeColor: mainAppColor,
                title: Text(
                  _homeProvider.currentLang == "ar"
                      ? "هل تريد اضافه الموقع ؟"
                      : "Do you want to add the Location?",
                  style: TextStyle(fontSize: 15),
                ),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue;
                    _homeProvider.setCheckedValue(newValue.toString());
                    print(_homeProvider.checkedValue);
                  });
                },
              ),
            ),
            _homeProvider.checkedValue == "true"
                ? Container(
                    width: _locData == null ? _width * 0.5 : _width * 0.55,
                    child: CustomButton(
                      btnColor: mainAppColor,
                      borderColor: accentColor,
                      onPressedFunction: () {
                        _getCurrentUserLocation();
                      },
                      btnStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                      btnLbl: _locData == null
                          ? AppLocalizations.of(context)!
                              .translate('choose_location')
                          : AppLocalizations.of(context)!
                              .translate('detect_location'),
                    ))
                : Text(
                    ' ',
                    style: TextStyle(height: 0),
                  ),
            CustomButton(
              btnLbl: AppLocalizations.of(context)!.translate('publish_ad'),
              btnColor: orangeColor,
              onPressedFunction: () async {
                if (_formKey.currentState!.validate() &
                    checkAddAdValidation(context,
                        imgFile: _imageFile,
                        adMainCategory: _selectedCategory,
                        adCity: _selectedCity)) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() => _isLoading = true);

                  for (Asset a in images) {
                    final bytes = await a.getByteData();
                    imagesBytes[a.identifier] = bytes.buffer.asUint8List();
                  }
                  final imagesData = images
                      .map((a) => MultipartFile.fromBytes(
                          imagesBytes[a.identifier],
                          filename: a.name))
                      .toList();

                  FormData formData = new FormData.fromMap({
                    "user_id": _authProvider.currentUser!.userId,
                    "ads_title": _adsTitle,
                    "ads_rooms": _adsRooms,
                    "ads_video": _adsVideo,
                    "ads_details": _adsDescription,
                    "ads_cat": _selectedCategory!.catId,
                    "ads_sub": _selectedSub!.catId,
                    "ads_marka":
                        _selectedMarka != null ? _selectedMarka!.markaId : "0",
                    "ads_model":
                        _selectedModel != null ? _selectedModel!.modelId : "0",
                    "ads_country": _selectedCountry != null
                        ? _selectedCountry!.countryId
                        : "0",
                    "ads_city": _selectedCity!.cityId,
                    "ads_price": _adsPrice,
                    "ads_phone": _adsPhone,
                    "ads_whatsapp": _adsWhatsapp,
                    "ads_gear": _selectedAdsGear == "اتوماتك" ||
                            _selectedAdsGear == "automatic"
                        ? "1"
                        : "0",
                    "ads_speedometer": _adsSpeedometer.toString(),
                    "ads_location": _locData != null
                        ? '${_locData!.latitude},${_locData!.longitude}'
                        : "",
                    "imgURL[]": imagesData,
                  });
                  final results = await _apiProvider.postWithDio(
                      Urls.ADD_AD_URL +
                          "?api_lang=${_authProvider.currentLang}",
                      body: formData);
                  setState(() => _isLoading = false);

                  if (results['response'] == "1") {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) {
                          return ConfirmationDialog(
                            title: results['message'],
                            message: AppLocalizations.of(context)!
                                .translate('ad_published_and_manage_my_ads'),
                          );
                        });
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/my_ads_screen');
                      _navigationProvider.upadateNavigationIndex(4);
                    });
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
    _navigationProvider = Provider.of<NavigationProvider>(context);
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
                  Text(AppLocalizations.of(context)!.translate('add_ad')!,
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
