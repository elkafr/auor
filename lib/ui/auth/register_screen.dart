import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/custom_widgets/buttons/custom_button.dart';
import 'package:auor/custom_widgets/custom_selector/custom_selector.dart';
import 'package:auor/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:auor/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:auor/custom_widgets/dialogs/confirmation_dialog.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/navigation_provider.dart';
import 'package:auor/providers/register_provider.dart';
import 'package:auor/providers/terms_provider.dart';
import 'package:auor/ui/account/active_account_screen.dart';
import 'package:auor/ui/account/terms_and_rules_screen.dart';
import 'package:auor/ui/auth/login_screen.dart';
import 'package:auor/ui/auth/widgets/select_country_bottom_sheet.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/commons.dart';
import 'package:auor/utils/urls.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  late RegisterProvider _registerProvider;
  bool _initalRun = true;
  bool _isLoading = false;
  ApiProvider _apiProvider = ApiProvider();
  TermsProvider _termsProvider = TermsProvider();
  NavigationProvider _navigationProvider = NavigationProvider();
  String _userName = '', _userPhone = '', _userEmail = '', _userPassword = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initalRun) {
      _registerProvider = Provider.of<RegisterProvider>(context);
      _registerProvider.getCountryList();
    }
  }

  Widget _buildBodyItem() {
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
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: _height * 0.02),
              child: Image.asset(
                'assets/images/logo.png',
                height: _height * 0.1,
                fit: BoxFit.cover,
                color: mainAppColor,
              ),
            ),
            CustomTextFormField(
              prefixIconIsImage: true,
              prefixIconImagePath: 'assets/images/user.png',
              hintTxt: AppLocalizations.of(context)!.translate('user_name'),
              validationFunc: validateUserName,
              onChangedFunc: (text) {
                _userName = text;
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/call.png',
                hintTxt: AppLocalizations.of(context)!.translate('phone_no'),
                validationFunc: validateUserPhone,
                onChangedFunc: (text) {
                  _userPhone = text;
                },
              ),
            ),
            CustomTextFormField(
              prefixIconIsImage: true,
              prefixIconImagePath: 'assets/images/mail.png',
              hintTxt: AppLocalizations.of(context)!.translate('email')!,

              onChangedFunc: (text) {
                _userEmail = text;
              },
              validationFunc: validateUserEmail,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: _width * 0.03, vertical: _height * 0.02),
              height: 50,
              width: _width,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet<dynamic>(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      context: context,
                      builder: (builder) {
                        return SelectCountryBottomSheet();
                      });
                },
                child: CustomSelector(
                  title: Consumer<RegisterProvider>(
                      builder: (context, registerProvider, child) {
                    return Text(
                        registerProvider.userCountry != null
                            ? registerProvider.userCountry!.countryName!
                            : AppLocalizations.of(context)!
                                .translate('country')!,
                        style: TextStyle(
                            fontSize: 14,
                            color: registerProvider.userCountry != null
                                ? Colors.black
                                : hintColor));
                  }),
                  icon: Image.asset('assets/images/city.png'),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: _height * 0.02),
              child: CustomTextFormField(
                isPassword: true,
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/key.png',
                hintTxt: AppLocalizations.of(context)!.translate('password'),
                validationFunc: validatePassword,
                onChangedFunc: (text) {
                  _userPassword = text;
                },
              ),
            ),
            CustomTextFormField(
              isPassword: true,
              prefixIconIsImage: true,
              prefixIconImagePath: 'assets/images/key.png',
              hintTxt:
                  AppLocalizations.of(context)!.translate('confirm_password'),
              validationFunc: validateConfirmPassword,
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    vertical: _height * 0.01, horizontal: _width * 0.07),
                child: Row(
                  children: <Widget>[
                    Consumer<RegisterProvider>(
                        builder: (context, registerProvider, child) {
                      return GestureDetector(
                        onTap: () => registerProvider
                            .setAcceptTerms(!registerProvider.acceptTerms),
                        child: Container(
                          width: 25,
                          height: 25,
                          child: registerProvider.acceptTerms
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 17,
                                )
                              : Container(),
                          decoration: BoxDecoration(
                            color: registerProvider.acceptTerms
                                ? Color(0xffA8C21C)
                                : Colors.white,
                            border: Border.all(
                              color: registerProvider.acceptTerms
                                  ? Color(0xffA8C21C)
                                  : hintColor,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      );
                    }),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndRulesScreen()));
                      },
                      child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: _width * 0.02),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .translate('accept_to_all')),
                                TextSpan(text: ' '),
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .translate('rules_and_terms'),
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Cairo',
                                        color: Color(0xffA8C21C))),
                              ],
                            ),
                          )),
                    ),
                  ],
                )),
            CustomButton(
              btnLbl: AppLocalizations.of(context)!.translate('make_account'),
              btnColor: orangeColor,
              onPressedFunction: () async {
                if (_formKey.currentState!.validate()) {
                  if (_registerProvider.userCountry != null) {
                    if (_registerProvider.acceptTerms) {
                      setState(() {
                        _isLoading = true;
                      });
                      final results =
                          await _apiProvider.post(Urls.REGISTER_URL, body: {
                        "user_name": _userName,
                        "user_phone": _userPhone,
                        "user_pass": _userPassword,
                        "user_pass_confirm": _userPassword,
                        "user_country":
                            _registerProvider.userCountry!.countryId,
                        "user_email": _userEmail
                      });

                      setState(() => _isLoading = false);
                      if (results['response'] == "1") {
                        _register1();
                      } else {
                        _register();
                      }
                    } else {
                      Commons.showToast(context,
                          message: AppLocalizations.of(context)!
                              .translate('accept_rules_and_terms')!,
                          color: Colors.red);
                    }
                  } else {
                    Commons.showToast(context,
                        message: AppLocalizations.of(context)!
                            .translate('country_validation')!);
                  }
                }
              },
            ),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: _height * 0.02),
                child: Text(
                  AppLocalizations.of(context)!.translate('has_account')!,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                )),
            CustomButton(
              btnLbl: AppLocalizations.of(context)!.translate('login'),
              btnColor: Colors.white,
              btnStyle: TextStyle(color: mainAppColor),
              onPressedFunction: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  _register() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return ConfirmationDialog(
            title: AppLocalizations.of(context)!
                .translate('account_has created_successfully'),
            message: AppLocalizations.of(context)!
                .translate('account_has created_successfully_use_app_now'),
          );
        });

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ActiveAccountScreen()));
    });
  }

  _register1() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return ConfirmationDialog(
            title: AppLocalizations.of(context)!
                .translate('account_has created_successfully'),
            message: AppLocalizations.of(context)!
                .translate('account_has created_successfully_use_app_now'),
          );
        });

    _navigationProvider.upadateNavigationIndex(0);
    Navigator.pushReplacementNamed(context, '/navigation');
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
                  Text(AppLocalizations.of(context)!.translate('register')!,
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
