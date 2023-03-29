import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/custom_widgets/buttons/custom_button.dart';
import 'package:auor/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:auor/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/commons.dart';
import 'package:auor/utils/urls.dart';
import 'package:provider/provider.dart';

class PhonePasswordRecoveryScreen extends StatefulWidget {
  @override
  _PhonePasswordRecoveryScreenState createState() =>
      _PhonePasswordRecoveryScreenState();
}

class _PhonePasswordRecoveryScreenState
    extends State<PhonePasswordRecoveryScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  ApiProvider _apiProvider = ApiProvider();
  late AuthProvider _authProvider;
  bool _isLoading = false;
  String _userPhone = '';
  final _formKey = GlobalKey<FormState>();

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: _height * 0.05),
              child: Image.asset(
                'assets/images/logo.png',
                height: _height * 0.2,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.translate('password_recovery')!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.only(bottom: _height * 0.02),
              child: Text(
                AppLocalizations.of(context)!.translate(
                    'enter_phone_no_to_send_code_to_recovery_password')!,
                style: TextStyle(color: Color(0xffC5C5C5), fontSize: 14),
              ),
            ),
            CustomTextFormField(
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/mail.png',
                hintTxt: AppLocalizations.of(context)!.translate('email'),
                onChangedFunc: (text) {
                  _userPhone = text;
                },
                validationFunc: validateUserEmail),
            SizedBox(
              height: _height * 0.02,
            ),
            _buildRetrievalCodeBtn()
          ],
        ),
      ),
    );
  }

  Widget _buildRetrievalCodeBtn() {
    return _isLoading
        ? Center(
            child: SpinKitFadingCircle(color: mainAppColor),
          )
        : CustomButton(
            btnLbl:
                AppLocalizations.of(context)!.translate('send_recovery_code'),
            onPressedFunction: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;
                });
                final results = await _apiProvider.post(
                    Urls.PASSSWORD_RECOVERY_URL +
                        "?api_lang=${_authProvider.currentLang}",
                    body: {
                      "user_email": _userPhone,
                    });

                setState(() => _isLoading = false);
                if (results['response'] == "1") {
                  _authProvider.setUserPhone(_userPhone);
                  Navigator.pushNamed(context, '/code_activation_screen');
                } else {
                  Commons.showError(context, results["message"]);
                }
              }
            },
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
                    flex: 1,
                  ),
                  Text(
                      AppLocalizations.of(context)!
                          .translate('password_recovery')!,
                      style: Theme.of(context).textTheme.headline1),
                  Spacer(
                    flex: 2,
                  ),
                ],
              )),
        ],
      )),
    );
  }
}
