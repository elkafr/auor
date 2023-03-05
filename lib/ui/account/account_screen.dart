import 'dart:async';

import 'package:auor/custom_widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auor/custom_widgets/dialogs/log_out_dialog.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/providers/navigation_provider.dart';
import 'package:auor/providers/terms_provider.dart';
import 'package:auor/shared_preferences/shared_preferences_helper.dart';
import 'package:auor/ui/account/about_app_screen.dart';
import 'package:auor/ui/account/app_commission_screen.dart';
import 'package:auor/ui/account/contact_with_us_screen.dart';
import 'package:auor/ui/account/language_screen.dart';
import 'package:auor/ui/account/personal_information_screen.dart';
import 'package:auor/ui/account/terms_and_rules_Screen.dart';
import 'package:auor/ui/auth/login_screen.dart';
import 'package:auor/ui/blacklist/blacklist_screen.dart';
import 'package:auor/ui/blacklist1/blacklist1_screen.dart';
import 'package:auor/ui/follow/follow_screen.dart';
import 'package:auor/ui/home/home_screen.dart';
import 'package:auor/ui/my_ads/my_ads_screen.dart';
import 'package:auor/ui/my_chats/my_chats_screen.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/error.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  double _height = 0, _width = 0;

  NavigationProvider? _navigationProvider;
  late AuthProvider _authProvider;

  late HomeProvider _homeProvider;

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 80,
          ),
          (_authProvider.currentUser == null)
              ? Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                            color: hintColor.withOpacity(0.4),
                          ),
                          color: Colors.white,
                        ),
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 70,
                          height: 70,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(7)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(4)),
                          Text(
                              _homeProvider.currentLang == "ar"
                                  ? "زائر"
                                  : "visitor",
                              style:
                                  TextStyle(color: mainAppColor, fontSize: 18)),
                          Text(
                            _homeProvider.currentLang == "ar"
                                ? "الحساب الشخصي"
                                : "personal account",
                            style: TextStyle(color: mainAppColor, fontSize: 16),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                        return CircleAvatar(
                          backgroundColor: accentColor,
                          backgroundImage: NetworkImage(
                              authProvider.currentUser!.userPhoto!),
                          maxRadius: 40,
                        );
                      }),
                      Padding(padding: EdgeInsets.all(7)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(4)),
                          Text(_authProvider.currentUser!.userName!,
                              style:
                                  TextStyle(color: mainAppColor, fontSize: 18)),
                          Text(
                            _homeProvider.currentLang == "ar"
                                ? "الحساب الشخصي"
                                : "personal account",
                            style: TextStyle(color: mainAppColor, fontSize: 16),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
          (_authProvider.currentUser == null)
              ? Text(
                  "",
                  style: TextStyle(height: 0),
                )
              : ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersonalInformationScreen())),
                  dense: true,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(color: mainAppColor, width: 1),
                    ),
                    child: Image.asset(
                      'assets/images/edit.png',
                      color: mainAppColor,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.translate("personal_info")!,
                    style: TextStyle(color: mainAppColor, fontSize: 16),
                  ),
                ),
          Padding(padding: EdgeInsets.all(5)),
          (_authProvider.currentUser == null)
              ? Text(
                  "",
                  style: TextStyle(height: 0),
                )
              : ListTile(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyAdsScreen())),
                  dense: true,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(color: mainAppColor, width: 1),
                    ),
                    child: Image.asset(
                      'assets/images/adds.png',
                      color: mainAppColor,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.translate("my_ads")!,
                    style: TextStyle(color: mainAppColor, fontSize: 15),
                  ),
                ),
          Padding(padding: EdgeInsets.all(5)),
          (_authProvider.currentUser == null)
              ? Text(
                  "",
                  style: TextStyle(height: 0),
                )
              : ListTile(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyChatsScreen())),
                  dense: true,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(color: mainAppColor, width: 1),
                    ),
                    child: Image.asset(
                      'assets/images/chat.png',
                      color: mainAppColor,
                    ),
                  ),
                  title: FutureBuilder<String?>(
                      future: Provider.of<HomeProvider>(context, listen: false)
                          .getUnreadMessage(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Center(
                              child: SpinKitFadingCircle(color: mainAppColor),
                            );
                          case ConnectionState.active:
                            return Text('');
                          case ConnectionState.waiting:
                            return Center(
                              child: SpinKitFadingCircle(color: mainAppColor),
                            );
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return Error(
                                //  errorMessage: snapshot.error.toString(),
                                errorMessage: AppLocalizations.of(context)!
                                    .translate('error'),
                              );
                            } else {
                              return Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate("my_chats")!,
                                    style: TextStyle(
                                        color: mainAppColor, fontSize: 16),
                                  ),
                                  Padding(padding: EdgeInsets.all(3)),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                    child: snapshot.data != "0"
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: _width * 0.01),
                                            child: Text(
                                              snapshot.data.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  height: 1.6),
                                            ))
                                        : Text(
                                            "",
                                            style: TextStyle(height: 0),
                                          ),
                                  ),
                                ],
                              );
                            }
                        }
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      }),
                ),
          Padding(padding: EdgeInsets.all(5)),
          (_authProvider.currentUser == null)
              ? Text(
                  "",
                  style: TextStyle(height: 0),
                )
              : ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlacklistScreen())),
                  dense: true,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(color: mainAppColor, width: 1),
                    ),
                    child: Image.asset(
                      'assets/images/chat.png',
                      color: mainAppColor,
                    ),
                  ),
                  title: Text(
                    _homeProvider.currentLang == "ar"
                        ? "القائمة السوداء"
                        : "Black list",
                    style: TextStyle(color: mainAppColor, fontSize: 16),
                  ),
                ),
          Padding(padding: EdgeInsets.all(5)),
          (_authProvider.currentUser == null)
              ? Text(
                  "",
                  style: TextStyle(height: 0),
                )
              : ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Blacklist1Screen())),
                  dense: true,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(color: mainAppColor, width: 1),
                    ),
                    child: Image.asset(
                      'assets/images/chat.png',
                      color: mainAppColor,
                    ),
                  ),
                  title: Text(
                    _homeProvider.currentLang == "ar"
                        ? "السلع والاعلانات الممنوعة"
                        : "Prohibited goods and ads",
                    style: TextStyle(color: mainAppColor, fontSize: 16),
                  ),
                ),
          Padding(padding: EdgeInsets.all(5)),
          (_authProvider.currentUser == null)
              ? Text(
                  "",
                  style: TextStyle(height: 0),
                )
              : ListTile(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FollowScreen())),
                  dense: true,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(color: mainAppColor, width: 1),
                    ),
                    child: Image.asset(
                      'assets/images/chat.png',
                      color: mainAppColor,
                    ),
                  ),
                  title: Text(
                    _homeProvider.currentLang == "ar" ? "المتابعة" : "Follow",
                    style: TextStyle(color: mainAppColor, fontSize: 16),
                  ),
                ),
          Padding(padding: EdgeInsets.all(5)),
          (_authProvider.currentUser == null)
              ? Text(
                  "",
                  style: TextStyle(height: 0),
                )
              : ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppCommissionScreen())),
                  dense: true,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(color: mainAppColor, width: 1),
                    ),
                    child: Icon(
                      FontAwesomeIcons.solidHandshake,
                      color: mainAppColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.translate("app_commission")!,
                    style: TextStyle(color: mainAppColor, fontSize: 16),
                  ),
                ),
          Padding(padding: EdgeInsets.all(5)),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => LanguageScreen())),
            dense: true,
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: mainAppColor, width: 1),
              ),
              child: Icon(
                FontAwesomeIcons.language,
                color: mainAppColor,
                size: 20,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.translate("language")!,
              style: TextStyle(color: mainAppColor, fontSize: 16),
            ),
          ),
          Padding(padding: EdgeInsets.all(5)),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutAppScreen())),
            dense: true,
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: mainAppColor, width: 1),
              ),
              child: Image.asset(
                'assets/images/about.png',
                color: mainAppColor,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.translate("about_app")!,
              style: TextStyle(color: mainAppColor, fontSize: 16),
            ),
          ),
          Padding(padding: EdgeInsets.all(5)),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => TermsAndRulesScreen())),
            dense: true,
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: mainAppColor, width: 1),
              ),
              child: Image.asset(
                'assets/images/conditions.png',
                color: mainAppColor,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.translate("rules_and_terms")!,
              style: TextStyle(color: mainAppColor, fontSize: 16),
            ),
          ),
          Padding(padding: EdgeInsets.all(5)),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ContactWithUsScreen())),
            dense: true,
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: mainAppColor, width: 1),
              ),
              child: Image.asset(
                'assets/images/call.png',
                color: mainAppColor,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.translate("contact_us")!,
              style: TextStyle(color: mainAppColor, fontSize: 16),
            ),
          ),
          Padding(padding: EdgeInsets.all(5)),
          (_authProvider.currentUser == null)
              ? ListTile(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen())),
                  dense: true,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(color: mainAppColor, width: 1),
                    ),
                    child: Image.asset(
                      'assets/images/logout.png',
                      color: mainAppColor,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.translate("login")!,
                    style: TextStyle(color: mainAppColor, fontSize: 16),
                  ),
                )
              : ListTile(
                  dense: true,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      border: Border.all(color: mainAppColor, width: 1),
                    ),
                    child: Icon(
                      FontAwesomeIcons.user,
                      color: mainAppColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.translate('logout')!,
                    style: TextStyle(color: mainAppColor, fontSize: 16),
                  ),
                  onTap: () {
                    showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) {
                          return LogoutDialog(
                            alertMessage: AppLocalizations.of(context)!
                                .translate('want_to_logout'),
                            onPressedConfirm: () {
                              Navigator.pop(context);
                              SharedPreferencesHelper.remove("user");

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                              _authProvider.setCurrentUser(null);
                            },
                          );
                        });
                  },
                ),
          SizedBox(
            height: 25,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: _width * 0.1, vertical: _height * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FutureBuilder<String?>(
                    future: Provider.of<TermsProvider>(context, listen: false)
                        .getTwitt(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        case ConnectionState.active:
                          return Text('');
                        case ConnectionState.waiting:
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Error(
                              //  errorMessage: snapshot.error.toString(),
                              errorMessage: AppLocalizations.of(context)!
                                  .translate('error'),
                            );
                          } else {
                            return GestureDetector(
                                onTap: () {
                                  launch(snapshot.data.toString());
                                },
                                child: Image.asset(
                                  'assets/images/twitter.png',
                                  height: 40,
                                  width: 40,
                                ));
                          }
                      }
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    }),
                FutureBuilder<String?>(
                    future: Provider.of<TermsProvider>(context, listen: false)
                        .getInst(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        case ConnectionState.active:
                          return Text('');
                        case ConnectionState.waiting:
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Error(
                              //  errorMessage: snapshot.error.toString(),
                              errorMessage: AppLocalizations.of(context)!
                                  .translate('error'),
                            );
                          } else {
                            return GestureDetector(
                                onTap: () {
                                  launch(snapshot.data.toString());
                                },
                                child: Image.asset(
                                  'assets/images/instagram.png',
                                  height: 40,
                                  width: 40,
                                ));
                          }
                      }
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    }),
                FutureBuilder<String?>(
                    future: Provider.of<TermsProvider>(context, listen: false)
                        .getFace(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        case ConnectionState.active:
                          return Text('');
                        case ConnectionState.waiting:
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Error(
                              //  errorMessage: snapshot.error.toString(),
                              errorMessage: AppLocalizations.of(context)!
                                  .translate('error'),
                            );
                          } else {
                            return GestureDetector(
                                onTap: () {
                                  launch(snapshot.data.toString());
                                },
                                child: Image.asset(
                                  'assets/images/facebook.png',
                                  height: 40,
                                  width: 40,
                                ));
                          }
                      }
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);
    return PageContainer(
      child: WillPopScope(
          onWillPop: () async {
            // This dialog will exit your app on saying yes
            return (await (showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    title: new Text(_homeProvider.currentLang == "ar"
                        ? 'هل انت متاكد ؟'
                        : 'are you sure ?'),
                    content: new Text(_homeProvider.currentLang == "ar"
                        ? 'هل تريد بالفعل الخروج من التطبيق ؟'
                        : 'Do you really want to exit the application?'),
                    actions: <Widget>[
                      CustomButton(
                          onPressedFunction: () =>
                              Navigator.of(context).pop(false),
                          btnLbl:
                              _homeProvider.currentLang == "ar" ? 'لا' : 'no'),
                      CustomButton(
                          onPressedFunction: () =>
                              Navigator.of(context).pop(true),
                          btnLbl: _homeProvider.currentLang == "ar"
                              ? 'نعم'
                              : 'yes'),
                    ],
                  ),
                ) as FutureOr<bool>?)) ??
                false;
          },
          child: Scaffold(
              body: Stack(
            children: <Widget>[
              _buildBodyItem(),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: mainAppColor,
                ),
                child: Center(
                  child: Text(
                      AppLocalizations.of(context)!.translate("my_account")!,
                      style: Theme.of(context).textTheme.headline1),
                ),
              )
            ],
          ))),
    );
  }
}
