import 'package:device_preview/device_preview.dart';

import './pages/account_page.dart';
import './pages/booking_page.dart';
import './pages/cart_page.dart';
import './pages/check_out_page.dart';
import './pages/intro_page.dart';
import './pages/login_page.dart';

import './pages/select_car_page.dart';
import './pages/select_city_page.dart';
import './pages/service_details_page.dart';
import './pages/service_page.dart';
import './pages/search_page.dart';
import './pages/splash_screen_page.dart';
import './pages/user_payment_page.dart';
import './widgets/con_pop_widget.dart';
import './widgets/otp_verify_widget.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:flutter/material.dart';

import './pages/home_page.dart';

void main() {
  runApp(MyApp()
      //   DevicePreview(
      //   builder: (context) => MyApp(),
      // )
      );
}

//void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
        maxWidth: 1200,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(450, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
        ],
      ),*/
      debugShowCheckedModeBanner: false,
      title: "Autoflipz",
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xffd72323)),
        fontFamily: 'Archia',
      ),
      initialRoute: SplashScreenPage.routeName,
      routes: {
        SplashScreenPage.routeName: (context) => SplashScreenPage(),
        HomePage.routeName: (context) => CanPopWidget(pageWidget: HomePage()),
        ServicePage.routeName: (context) => ServicePage(),
        ServiceDetailsPage.routeName: (context) => ServiceDetailsPage(),
        CartPage.routeName: (context) => CanPopWidget(pageWidget: CartPage()),
        AccountPage.routeName: (context) =>
            CanPopWidget(pageWidget: AccountPage()),
        LoginPage.routeName: (context) => LoginPage(),
        IntroPage.routeName: (context) => IntroPage(),
        SelectCityPage.routeName: (context) => SelectCityPage(),
        SearchPage.routeName: (context) =>
            CanPopWidget(pageWidget: SearchPage()),
        UserPaymentPage.routeName: (context) => UserPaymentPage(),
        SelectCarPage.routeName: (context) => SelectCarPage(),
        CheckOutPage.routeName: (context) => CheckOutPage(),
        BookingPage.routeName: (context) => BookingPage(),
        OTPVerifyWidget.routeName: (context) => OTPVerifyWidget(),
      },
    );
  }
}
