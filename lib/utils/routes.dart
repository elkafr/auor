import 'package:auor/ui/auth/code_activation_screen.dart';
import 'package:auor/ui/auth/login_screen.dart';
import 'package:auor/ui/auth/new_password_screen.dart';
import 'package:auor/ui/auth/phone_password_recovery_screen.dart';
import 'package:auor/ui/auth/register_screen.dart';
import 'package:auor/ui/bottom_navigation.dart/bottom_navigation_bar.dart';
import 'package:auor/ui/home/cats_screen.dart';
import 'package:auor/ui/my_ads/my_ads_screen.dart';
import 'package:auor/ui/notification/notification_screen.dart';
import 'package:auor/ui/splash/splash_screen.dart';

final routes = {
  '/': (context) => SplashScreen(),
  '/login_screen': (context) => LoginScreen(),
  '/phone_password_reccovery_screen': (context) =>
      PhonePasswordRecoveryScreen(),
  '/code_activation_screen': (context) => CodeActivationScreen(),
  '/new_password_screen': (context) => NewPasswordScreen(),
  '/register_screen': (context) => RegisterScreen(),
  '/navigation': (context) => BottomNavigation(),
  '/my_ads_screen': (context) => MyAdsScreen(),
  '/notification_screen': (context) => NotificationScreen(),
  '/cats_screen': (context) => CatsScreen()
};
