import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/custom_widgets/buttons/custom_button.dart';
import 'package:auor/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:auor/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:auor/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/country.dart';
import 'package:auor/models/user.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/shared_preferences/shared_preferences_helper.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/commons.dart';
import 'package:auor/utils/urls.dart';
import 'package:provider/provider.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  @override
  _EditPersonalInfoScreenState createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen>
    with ValidationMixin {
  double _height = 0, _width = 0;
  String? _userName = '', _userPhone = '', _userEmail = '';
  late AuthProvider _authProvider;
  bool _initialRun = true;
  bool _isLoading = false;
  Country? _selectedCountry;
  bool _initSelectedCountry = true;
  Future<List<Country>>? _countryList;
  late HomeProvider _homeProvider;
  final _formKey = GlobalKey<FormState>();
  ApiProvider _apiProvider = ApiProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);
      _homeProvider = Provider.of<HomeProvider>(context);

      _countryList = _homeProvider.getCountryList();
      _userName = _authProvider.currentUser!.userName;
      _userPhone = _authProvider.currentUser!.userPhone;
      _userEmail = _authProvider.currentUser!.userEmail;
      _initialRun = false;
    }
  }

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Container(
        height: _height,
        width: _width,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              CustomTextFormField(
                  initialValue: _userName,
                  prefixIconIsImage: true,
                  prefixIconImagePath: 'assets/images/user.png',
                  hintTxt: AppLocalizations.of(context)!.translate('user_name'),
                  validationFunc: validateUserName),
              Container(
                margin: EdgeInsets.symmetric(vertical: _height * 0.02),
                child: CustomTextFormField(
                    initialValue: _userPhone,
                    prefixIconIsImage: true,
                    prefixIconImagePath: 'assets/images/call.png',
                    hintTxt:
                        AppLocalizations.of(context)!.translate('phone_no'),
                    validationFunc: validateUserPhone),
              ),
              CustomTextFormField(
                  initialValue: _userEmail,
                  prefixIconIsImage: true,
                  prefixIconImagePath: 'assets/images/mail.png',
                  hintTxt: AppLocalizations.of(context)!.translate('email'),
                  validationFunc: validateUserEmail),
              Container(
                margin: EdgeInsets.symmetric(vertical: _height * 0.02),
                child: FutureBuilder<List<Country>>(
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
                        if (_initSelectedCountry) {
                          for (int i = 0; i < snapshot.data!.length; i++) {
                            if (_authProvider.currentUser!.userCountryName ==
                                snapshot.data![i].countryName) {
                              _selectedCountry = snapshot.data![i];
                              break;
                            }
                          }
                          _initSelectedCountry = false;
                        }
                        return DropDownListSelector(
                          dropDownList: countryList,
                          hint: AppLocalizations.of(context)!
                              .translate('country'),
                          onChangeFunc: (newValue) {
                            setState(() {
                              _selectedCountry = newValue;
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
                // height: _height * 0.085,
                // width: _width,
                // child:   InkWell(
                //   onTap: (){
                //      showModalBottomSheet(
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                //                   topRight: Radius.circular(20)),
                //                 ),
                //                 context: context,
                //                 builder: (builder) {
                //                   return SelectCountryBottomSheet();
                //   });
                //   },
                //   child: CustomSelector(

                //     title: Text('الدولة',
                //     style: TextStyle(
                //       fontSize: 14,color: Colors.black
                //     ),),
                //     icon: Image.asset('assets/images/city.png'),
                //   ),
                // ),
              ),
              Spacer(),
              CustomButton(
                btnLbl: AppLocalizations.of(context)!.translate('save'),
                btnColor: mainAppColor,
                onPressedFunction: () async {
                  if (_formKey.currentState!.validate() &
                      checkValidationCountry(context,
                          country: _selectedCountry)) {
                    setState(() => _isLoading = true);
                    FormData formData = new FormData.fromMap({
                      "user_id": _authProvider.currentUser!.userId,
                      "user_name": _userName,
                      "user_phone": _userPhone,
                      "user_email": _userEmail,
                      "user_country": _selectedCountry!.countryId,
                    });
                    final results = await _apiProvider.postWithDio(
                        Urls.PROFILE_URL +
                            "?api_lang=${_authProvider.currentLang}",
                        body: formData);
                    setState(() => _isLoading = false);

                    if (results['response'] == "1") {
                      _authProvider
                          .setCurrentUser(User.fromJson(results["user"]));
                      SharedPreferencesHelper.save(
                          "user", _authProvider.currentUser);
                      Commons.showToast(context, message: results["message"]);
                      Navigator.pop(context);
                    } else {
                      Commons.showError(context, results["message"]);
                    }
                  }
                },
              ),
              SizedBox(
                height: _height * 0.02,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
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
                  Text(AppLocalizations.of(context)!.translate('edit_info')!,
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
