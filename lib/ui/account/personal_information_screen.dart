import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/custom_widgets/buttons/custom_button.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/user.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/shared_preferences/shared_preferences_helper.dart';
import 'package:auor/ui/account/edit_password_screen.dart';
import 'package:auor/ui/account/edit_personal_info_screen.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/commons.dart';
import 'package:auor/utils/urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

class PersonalInformationScreen extends StatefulWidget {
  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  double _height = 0, _width = 0;
  bool _isLoading = false;
  File? _imageFile;
  dynamic _pickImageError;
  ApiProvider _apiProvider = ApiProvider();
  final _picker = ImagePicker();
  late AuthProvider _authProvider;

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile =
          await (_picker.getImage(source: source) as FutureOr<PickedFile>);
      _imageFile = File(pickedFile.path);
      if (_imageFile != null) {
        setState(() {
          _isLoading = true;
        });

        FormData formData = new FormData.fromMap({
          "user_id": _authProvider.currentUser!.userId,
          "user_name": _authProvider.currentUser!.userName,
          "user_phone": _authProvider.currentUser!.userPhone,
          "user_email": _authProvider.currentUser!.userEmail,
          "user_country": _authProvider.currentUser!.userCountry,
          "imgURL": _imageFile != null
              ? await MultipartFile.fromFile(_imageFile!.path,
                  filename: Path.basename(_imageFile!.path))
              : null,
        });
        final results = await _apiProvider.postWithDio(
            Urls.PROFILE_URL + "?api_lang=${_authProvider.currentLang}",
            body: formData);
        setState(() => _isLoading = false);

        if (results['response'] == "1") {
          _authProvider.setCurrentUser(User.fromJson(results["user"]));
          SharedPreferencesHelper.save("user", _authProvider.currentUser);
          Commons.showToast(context!, message: results["message"]);
        } else {
          Commons.showError(context!, results["message"]);
        }
      }
    } catch (e) {
      _pickImageError = e;
    }
  }

  Widget _buildItem({required String title, required String value}) {
    return Container(
      height: _height * 0.05,
      margin: EdgeInsets.symmetric(horizontal: _width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
          ),
          Text(
            value,
            style: TextStyle(
                color: mainAppColor, fontSize: 15, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Container(
        height: _height,
        width: _width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Stack(
              children: <Widget>[
                Consumer<AuthProvider>(builder: (context, authProvider, child) {
                  return CircleAvatar(
                    backgroundColor: mainAppColor,
                    radius: _height * 0.09,
                    backgroundImage:
                        NetworkImage(authProvider.currentUser!.userPhoto!),
                  );
                }),
                Positioned(
                  top: 2,
                  left: _width * 0.18,
                  child: GestureDetector(
                    onTap: () => _onImageButtonPressed(ImageSource.gallery,
                        context: context),
                    child: Container(
                      child: CircleAvatar(
                        backgroundColor: accentColor,
                        child: Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Consumer<AuthProvider>(builder: (context, authProvider, child) {
              return _buildItem(
                  title: AppLocalizations.of(context)!.translate('your_name')!,
                  value: authProvider.currentUser!.userName!);
            }),
            Divider(
              thickness: 1.2,
              color: Colors.grey[300],
            ),
            Consumer<AuthProvider>(builder: (context, authProvider, child) {
              return _buildItem(
                  title: AppLocalizations.of(context)!.translate('phone_no')!,
                  value: authProvider.currentUser!.userPhone!);
            }),
            Divider(
              thickness: 1.2,
              color: Colors.grey[300],
            ),
            Consumer<AuthProvider>(builder: (context, authProvider, child) {
              return _buildItem(
                  title: AppLocalizations.of(context)!.translate('email')!,
                  value: authProvider.currentUser!.userEmail!);
            }),
            Divider(
              thickness: 1.2,
              color: Colors.grey[300],
            ),
            Consumer<AuthProvider>(builder: (context, authProvider, child) {
              return _buildItem(
                  title: AppLocalizations.of(context)!.translate('country')!,
                  value: authProvider.currentUser!.userCountryName!);
            }),
            Spacer(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: _width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: _width * 0.47,
                    child: CustomButton(
                      defaultMargin: false,
                      btnLbl:
                          AppLocalizations.of(context)!.translate('edit_info'),
                      btnColor: mainAppColor,
                      onPressedFunction: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPersonalInfoScreen())),
                    ),
                  ),
                  Container(
                    width: _width * 0.47,
                    child: CustomButton(
                      btnColor: Colors.white,
                      btnStyle: TextStyle(
                          color: mainAppColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                      defaultMargin: false,
                      btnLbl: AppLocalizations.of(context)!
                          .translate('edit_password'),
                      onPressedFunction: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPasswordScreen())),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _height * 0.02,
            )
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
                      onPressed: () => Navigator.pop(context)),
                  Spacer(
                    flex: 2,
                  ),
                  Text(
                      AppLocalizations.of(context)!.translate("personal_info")!,
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
