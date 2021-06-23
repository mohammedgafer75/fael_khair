import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fael_khair/Screens/home_page.dart';
import 'package:fael_khair/localization_methods.dart';
import 'package:fael_khair/set_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Screens/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(FaelKhair());

class FaelKhair extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _FaelKhairState state = context.findAncestorStateOfType<_FaelKhairState>();
    state.setLocale(locale);
  }

  @override
  _FaelKhairState createState() => _FaelKhairState();
}

class _FaelKhairState extends State<FaelKhair> {
  @override
  void initState() {
    super.initState();
    check_login();
  }

  SharedPreferences sharedpreference;
  int check;
  Future<void> check_login() async {
    sharedpreference = await SharedPreferences.getInstance();
    var login = sharedpreference.getString("login");
    if (login == null) {
      return check = 0;
    } else {
      return check = 1;
    }
  }

  Locale _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null || check == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MaterialApp(
        locale: _locale,
        supportedLocales: [Locale('en', 'US'), Locale('ar', 'EG')],
        localizationsDelegates: [
          SetLocalization.localizationsDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        localeResolutionCallback: (deviceLocal, supportesLocale) {
          for (var locale in supportesLocale) {
            if (locale.languageCode == deviceLocal.languageCode &&
                locale.countryCode == deviceLocal.countryCode) {
              return deviceLocal;
            }
          }
          return supportesLocale.first;
        },
        title: 'Fael Khair',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: AnimatedSplashScreen(
          splash: Image(
            image: AssetImage("images/Logo.png"),
          ),
          splashIconSize: 350.0,
          //duration: 10000,
          backgroundColor: Colors.white,
          //centered: true,
          splashTransition: SplashTransition.fadeTransition,
          animationDuration: Duration(milliseconds: 2500),
          nextScreen: check == 0 ? SignIn_page() : MyHomePage(),
        ),
      );
    }
  }
}
