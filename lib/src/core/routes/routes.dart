
import 'package:flutter/material.dart';
import 'package:learning_app/src/core/routes/routes_name.dart';
import 'package:learning_app/src/features/all_categories/page/all_categories_page.dart';
import 'package:learning_app/src/features/auth/pages/forgot_page.dart';
import 'package:learning_app/src/features/auth/pages/login_page.dart';
import 'package:learning_app/src/features/auth/pages/resend_page.dart';
import 'package:learning_app/src/features/certificate/certificate_detail.dart';
import 'package:learning_app/src/features/certificate/certificate_screen.dart';
import 'package:learning_app/src/features/home/page/home_page.dart';
import 'package:learning_app/src/features/profile/page/profile_page.dart';
import 'package:learning_app/src/features/settings/setting_page.dart';
import 'package:learning_app/src/features/splash/splash/splash_page.dart';
import 'package:learning_app/src/features/view_course/page/explore_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RoutesName.splashPage:
        return MaterialPageRoute(builder: (context)=>const SplashPage());
      case RoutesName.myHomePage:
        return MaterialPageRoute(builder: (context)=>const HomePage());
      case RoutesName.loginPage:
        return MaterialPageRoute(builder: (context)=>const LoginPage());

      case RoutesName.forgotPage:
        return MaterialPageRoute(builder: (context)=>const ForgotPage());
      case RoutesName.resendPage:
        return MaterialPageRoute(builder: (context)=>const ResendPage());
      case RoutesName.explorePage:
        return MaterialPageRoute(builder: (context)=>const ExplorePage());

      case RoutesName.profilePage:
        return MaterialPageRoute(builder: (context)=>const ProfilePage());
      case RoutesName.settingPage:
        return MaterialPageRoute(builder: (context)=>const SettingPage());
      case RoutesName.certificateScreen:
        return MaterialPageRoute(builder: (context)=>const CertificateListScreen());
      case RoutesName.certificateDetailScreen:
        return MaterialPageRoute(builder: (context)=>const CertificateDetailScreen());




    default:
        return MaterialPageRoute(builder: (context){
          return const Scaffold(
            body: Center(
              child: Text('No route generate'),
            ),
          );
        });
    }
  }
}