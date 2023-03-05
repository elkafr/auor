import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auor/custom_widgets/connectivity/network_indicator.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/user.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/navigation_provider.dart';
import 'package:auor/shared_preferences/shared_preferences_helper.dart';
import 'package:auor/ui/add_ad/widgets/add_ad_bottom_sheet.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/badge_tab_bar.dart';
import '../notification/notification_screen.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  bool _initialRun = true;
  late AuthProvider _authProvider;
  late NavigationProvider _navigationProvider;

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  //     new FlutterLocalNotificationsPlugin();
  ValueNotifier<int> notificationCounterValueNotifer = ValueNotifier(0);

  void _iOSPermission() {
    // _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
  }

  // void _firebaseCloudMessagingListeners() {
  //   var android = new AndroidInitializationSettings('mipmap/ic_launcher');
  //   var ios = new IOSInitializationSettings();
  //   var platform = new InitializationSettings(android: android, iOS: ios);
  //
  //   _flutterLocalNotificationsPlugin.initialize(platform,
  //       onSelectNotification: selectNotification);
  //
  //   if (Platform.isIOS) _iOSPermission();
  //   FirebaseMessaging.onMessage.listen((event) {
  //     print('on message ${event.data}');
  //     print("onMessage: ${event.data}");
  //     notificationCounterValueNotifer.value++;
  //     notificationCounterValueNotifer.notifyListeners();
  //     FlutterAppBadger.updateBadgeCount(
  //         notificationCounterValueNotifer.value + 1);
  //     _showNotification(event.data);
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //     Navigator.push(context,
  //         MaterialPageRoute(builder: (context) => NotificationScreen()));
  //   });
  // }

  // _showNotification(Map<String, dynamic> message) async {
  //   var android = new AndroidNotificationDetails(
  //     'channel id',
  //     "CHANNLE NAME",
  //     channelDescription: "channelDescription",
  //   );
  //   var iOS = new IOSNotificationDetails();
  //   var platform = new NotificationDetails(android: android, iOS: iOS);
  //   await _flutterLocalNotificationsPlugin.show(
  //       0,
  //       message['notification']['title'],
  //       message['notification']['body'],
  //       platform);
  // }

//   void selectNotification(String? payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: $payload');
// // Here you can check notification payload and redirect user to the respective screen
//       await Navigator.push(
//         context,
//         MaterialPageRoute<void>(builder: (context) => NotificationScreen()),
//       );
//     }
//   }

  Future<Null> _checkIsLogin() async {
    var userData = await SharedPreferencesHelper.read("user");
    if (userData != null) {
      _authProvider.setCurrentUser(User.fromJson(userData));
      // _firebaseCloudMessagingListeners();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);
      _checkIsLogin();
      _initialRun = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    return NetworkIndicator(
        child: Scaffold(
      body: _navigationProvider.selectedContent,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: BadgeTabBar(
              image: FontAwesomeIcons.home,
              isSelected: _navigationProvider.navigationIndex == 0,
            ),
            label: AppLocalizations.of(context)!.translate('all'),
          ),
          BottomNavigationBarItem(
              icon: BadgeTabBar(
                image: Icons.favorite,
                isSelected: _navigationProvider.navigationIndex == 1,
              ),
              label: AppLocalizations.of(context)!.translate('favourite')),
          BottomNavigationBarItem(
              icon: BadgeTabBar(
                image: Icons.add_circle,
                isSelected: _navigationProvider.navigationIndex == 2,
                name: "333",
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: BadgeTabBar(
                image: Icons.notifications,
                isSelected: _navigationProvider.navigationIndex == 3,
                notificationCount: notificationCounterValueNotifer.value,
              ),
              label: _authProvider.currentLang == "ar"
                  ? "الاشعارات"
                  : "notification"),
          BottomNavigationBarItem(
              icon: BadgeTabBar(
                image: Icons.mail,
                isSelected: _navigationProvider.navigationIndex == 4,
              ),
              label:
                  _authProvider.currentLang == "ar" ? "الرسائل" : "messages"),
        ],
        currentIndex: _navigationProvider.navigationIndex,
        selectedItemColor: mainAppColor,
        unselectedItemColor: Color(0xFFC4C4C4),
        onTap: (int index) {
          if (index == 0 && _navigationProvider.navigationIndex == 0) {
            _navigationProvider
                .setMapIsActive(!_navigationProvider.mapIsActive);
          } else if ((index == 1 || index == 2 || index == 3 || index == 4) &&
              _authProvider.currentUser == null) {
            Navigator.pushNamed(context, '/login_screen');
          } else if (index == 2) {
            showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                context: context,
                builder: (builder) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: AddAdBottomSheet());
                });
          } else {
            _navigationProvider.upadateNavigationIndex(index);
            if (index == 3) {
              notificationCounterValueNotifer.value = 0;
            }
          }
        },
        elevation: 5,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    ));
  }
}
