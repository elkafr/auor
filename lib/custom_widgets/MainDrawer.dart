import 'package:auor/ui/account/app_commission_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auor/custom_widgets/dialogs/log_out_dialog.dart';
import 'package:auor/custom_widgets/dialogs/log_out_dialog.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/providers/navigation_provider.dart';
import 'package:auor/providers/terms_provider.dart';
import 'package:auor/shared_preferences/shared_preferences_helper.dart';
import 'package:auor/ui/account/about_app_screen.dart';
import 'package:auor/ui/account/contact_with_us_screen.dart';
import 'package:auor/ui/account/language_screen.dart';
import 'package:auor/ui/account/personal_information_screen.dart';
import 'package:auor/ui/account/personal_information_screen.dart';
import 'package:auor/ui/account/policy_screen.dart';
import 'package:auor/ui/account/terms_and_rules_Screen.dart';
import 'package:auor/ui/auth/login_screen.dart';
import 'package:auor/ui/blacklist/blacklist_screen.dart';
import 'package:auor/ui/blacklist1/blacklist1_screen.dart';
import 'package:auor/ui/follow/follow_screen.dart';
import 'package:auor/ui/home/home_screen.dart';
import 'package:auor/ui/my_ads/my_ads_screen.dart';
import 'package:auor/ui/my_chats/my_chats_screen.dart';
import 'package:auor/ui/my_chats/my_chats_screen.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/commons.dart';
import 'package:auor/utils/error.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainDrawer();
  }
}

class _MainDrawer extends State<MainDrawer> {
  double _height = 0, _width = 0;

  late NavigationProvider _navigationProvider;
  late AuthProvider _authProvider;

  late HomeProvider _homeProvider;

  bool _initialRun = true;

  bool _isLoading = false;
  ApiProvider _apiProvider = ApiProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);
      _navigationProvider = Provider.of<NavigationProvider>(context);
      _homeProvider = Provider.of<HomeProvider>(context);

      _initialRun = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 20,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
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
                            Text(_homeProvider.currentLang=="ar"?"زائر":"Visitor",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                            Text(
                              _homeProvider.currentLang=="ar"?"الحساب الشخصي":"Personal account",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                                style: TextStyle(
                                    color: mainAppColor, fontSize: 18)),
                            Text(
                              _homeProvider.currentLang == "ar"
                                  ? "الحساب الشخصي"
                                  : "personal account.",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
            Container(
              color: hintColor,
              height: 1,
              margin: EdgeInsets.all(5),
              width: _width,
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
                        height: 20,
                        width: 20,
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
                        height: 20,
                        width: 20,
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
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyChatsScreen())),
                    dense: true,
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(color: mainAppColor, width: 1),
                      ),
                      child: Image.asset(
                        'assets/images/chat.png',
                        height: 20,
                        width: 20,
                        color: mainAppColor,
                      ),
                    ),
                    title: FutureBuilder<String?>(
                        future:
                            Provider.of<HomeProvider>(context, listen: false)
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
                        height: 20,
                        width: 20,
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
                      builder: (context) => AppCommissionScreen())),
              dense: true,
              leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: mainAppColor, width: 1),
                ),
                child: Image.asset(
                  'assets/images/chat.png',
                  height: 20,
                  width: 20,
                  color: mainAppColor,
                ),
              ),
              title: Text( AppLocalizations.of(context)!.translate("app_commission")!,
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
                        height: 20,
                        width: 20,
                        color: mainAppColor,
                      ),
                    ),
                    title: Text(
                      _homeProvider.currentLang == "ar"
                          ? " الاعلانات الممنوعة"
                          : "Prohibited  ads",
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
                            builder: (context) => FollowScreen())),
                    dense: true,
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(color: mainAppColor, width: 1),
                      ),
                      child: Image.asset(
                        'assets/images/chat.png',
                        height: 20,
                        width: 20,
                        color: mainAppColor,
                      ),
                    ),
                    title: Text(
                      _homeProvider.currentLang == "ar" ? "المتابعة" : "Follow",
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
                  height: 20,
                  width: 20,
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
                  MaterialPageRoute(builder: (context) => PolicyScreen())),
              dense: true,
              leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: mainAppColor, width: 1),
                ),
                child: Image.asset(
                  'assets/images/about.png',
                  height: 20,
                  width: 20,
                  color: mainAppColor,
                ),
              ),
              title: Text(
                _homeProvider.currentLang == "ar"
                    ? "سياسة الخصوصية"
                    : "Privacy policy",
                style: TextStyle(color: mainAppColor, fontSize: 16),
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),
            ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TermsAndRulesScreen())),
              dense: true,
              leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: mainAppColor, width: 1),
                ),
                child: Image.asset(
                  'assets/images/conditions.png',
                  height: 20,
                  width: 20,
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
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ContactWithUsScreen())),
              dense: true,
              leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: mainAppColor, width: 1),
                ),
                child: Image.asset(
                  'assets/images/call.png',
                  height: 20,
                  width: 20,
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
                        height: 20,
                        width: 20,
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
                                _navigationProvider.upadateNavigationIndex(0);
                                Navigator.pushReplacementNamed(
                                    context, '/navigation');
                                _authProvider.setCurrentUser(null);
                              },
                            );
                          });
                    },
                  ),
            _authProvider.currentUser != null
                ? ListTile(
                    dense: true,
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        border: Border.all(color: mainAppColor, width: 1),
                      ),
                      child: Icon(
                        FontAwesomeIcons.user,
                        size: 20,
                        color: mainAppColor,
                      ),
                    ),
                    title: Text(
                      _homeProvider.currentLang == "ar"
                          ? "حذف الحساب"
                          : "Delect account",
                      style: TextStyle(color: mainAppColor, fontSize: 15),
                    ),
                    onTap: () {
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (_) {
                            return LogoutDialog(
                              alertMessage: "هل تريد بالفعل حذف الحساب ؟",
                              onPressedConfirm: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                final results = await _apiProvider.get(
                                    "http://auor-app.com/api/delete_account/"
                                    "?user_id=${_authProvider.currentUser!.userId}&api_lang=${_authProvider.currentLang}");

                                setState(() => _isLoading = false);
                                if (results['response'] == "1") {
                                  Commons.showToast(context,
                                      message: results["message"]);
                                } else {
                                  Commons.showError(
                                      context, results["message"]);
                                }
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
                  )
                : Text(""),
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
                                  child: Icon(
                                    FontAwesomeIcons.twitter,
                                    color: orangeColor,
                                    size: 30,
                                  ));
                            }
                        }
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      }),
                  FutureBuilder<String?>(
                      future: Provider.of<TermsProvider>(context, listen: false)
                          .getSnap(),
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
                                  child: Icon(
                                    FontAwesomeIcons.snapchat,
                                    color: orangeColor,
                                    size: 30,
                                  ));
                            }
                        }
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      }),
                  FutureBuilder<String?>(
                      future: Provider.of<TermsProvider>(context, listen: false)
                          .getToktok(),
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
                                    "assets/images/tiktok.png",
                                    width: 30,
                                    color: orangeColor,
                                  ));
                            }
                        }
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      }),
                  FutureBuilder<String?>(
                      future: Provider.of<TermsProvider>(context, listen: false)
                          .getYou(),
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
                                  child: Icon(
                                    FontAwesomeIcons.youtube,
                                    color: orangeColor,
                                    size: 30,
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
                                  child: Icon(
                                    FontAwesomeIcons.instagram,
                                    color: orangeColor,
                                    size: 30,
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
                                  child: Icon(
                                    FontAwesomeIcons.facebook,
                                    color: orangeColor,
                                    size: 30,
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
        ));
  }
}
