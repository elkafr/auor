import 'package:auor/ui/home/home_screen.dart';
import 'package:auor/ui/notification/notification_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/providers/ad_details_provider.dart';
import 'package:auor/providers/add_ad_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/chat_provider.dart';
import 'package:auor/providers/comment_provider.dart';
import 'package:auor/providers/commission_app_provider.dart';
import 'package:auor/providers/favourite_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/providers/my_ads_provider.dart';
import 'package:auor/providers/navigation_provider.dart';
import 'package:auor/providers/notification_provider.dart';
import 'package:auor/providers/received_msgs_provider.dart';
import 'package:auor/providers/register_provider.dart';
import 'package:auor/providers/section_ads_provider.dart';
import 'package:auor/providers/seller_ads_provider.dart';
import 'package:auor/shared_preferences/shared_preferences_helper.dart';
import 'package:auor/theme/style.dart';
import 'package:auor/utils/routes.dart';
import 'package:provider/provider.dart';

import 'locale/locale_helper.dart';
import 'providers/about_app_provider.dart';
import 'providers/terms_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);

  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications',
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    run();
  });
}

void run() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  onLocaleChange(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Future<void> _getLanguage() async {
    String language = await SharedPreferencesHelper.getUserLang();
    onLocaleChange(Locale(language));
  }

  @override
  void initState() {
    super.initState();

    helper.onLocaleChanged = onLocaleChange;
    _locale = new Locale('en');
    _getLanguage();
    Firebase.initializeApp().whenComplete(() {
      FirebaseMessaging.instance
          .getToken()
          .then((value) => print("token -- $value"));
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
              requestAlertPermission: false,
              requestBadgePermission: false,
              requestSoundPermission: false,
              onDidReceiveLocalNotification: (
                int id,
                String? title,
                String? body,
                String? payload,
              ) async {});

      var initialzationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettings = InitializationSettings(
          android: initialzationSettingsAndroid,
          iOS: initializationSettingsIOS);

     // flutterLocalNotificationsPlugin.initialize(initializationSettings,
        //  onDidReceiveNotificationResponse : selectNotification);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification!;
        AndroidNotification android = message.notification!.android!;
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
              ),
            ));
      });
    });
  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
      var userData = await SharedPreferencesHelper.read("user");
// Here you can check notification payload and redirect user to the respective screen
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (context) =>
                userData != null ? NotificationScreen() : HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, RegisterProvider?>(
            create: (_) => RegisterProvider(),
            update: (_, auth, registerProvider) =>
                registerProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, AddAdProvider?>(
            create: (_) => AddAdProvider(),
            update: (_, auth, addAdProvider) => addAdProvider?..update(auth),
          ),
          ChangeNotifierProvider(
            create: (_) => NavigationProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, AdDetailsProvider?>(
            create: (_) => AdDetailsProvider(),
            update: (_, auth, adDetailsProvider) =>
                adDetailsProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, AboutAppProvider?>(
            create: (_) => AboutAppProvider(),
            update: (_, auth, aboutAppProvider) =>
                aboutAppProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, CommisssionAppProvider?>(
            create: (_) => CommisssionAppProvider(),
            update: (_, auth, commissionAppProvider) =>
                commissionAppProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, TermsProvider?>(
            create: (_) => TermsProvider(),
            update: (_, auth, termsProvider) => termsProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, NotificationProvider?>(
            create: (_) => NotificationProvider(),
            update: (_, auth, notificationProvider) =>
                notificationProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, ReceivedMsgsProvider?>(
            create: (_) => ReceivedMsgsProvider(),
            update: (_, auth, receivedMsgsProvider) =>
                receivedMsgsProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, ChatProvider?>(
            create: (_) => ChatProvider(),
            update: (_, auth, chatProvider) => chatProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, SectionAdsProvider?>(
            create: (_) => SectionAdsProvider(),
            update: (_, auth, sectionAdsProvider) =>
                sectionAdsProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, SellerAdsProvider?>(
            create: (_) => SellerAdsProvider(),
            update: (_, auth, sellerAdsProvider) =>
                sellerAdsProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, HomeProvider?>(
            create: (_) => HomeProvider(),
            update: (_, auth, homeProvider) => homeProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, MyAdsProvider?>(
            create: (_) => MyAdsProvider(),
            update: (_, auth, myAdsProvider) => myAdsProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, CommentProvider?>(
            create: (_) => CommentProvider(),
            update: (_, auth, commentProvider) =>
                commentProvider?..update(auth),
          ),
          ChangeNotifierProxyProvider<AuthProvider, FavouriteProvider?>(
            create: (_) => FavouriteProvider(),
            update: (_, auth, favouriteProvider) =>
                favouriteProvider?..update(auth),
          ),
        ],
        child: MaterialApp(
          locale: _locale,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('tr', ''),
            Locale('nl', ''),
            Locale('ar', ''),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          debugShowCheckedModeBanner: false,
          title: 'auor',
          theme: themeData(),
          routes: routes,
        ));
  }
}
