import '../pages/login_page.dart';
import '../services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroPage extends StatefulWidget {
  static String routeName = "/intro-page";

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<Slide> slides = new List();

  Future<String> getInitialRoute() async {
    bool _isFirstTime = await isFirstTime().then((onValue) {
      return onValue;
    });
    if (_isFirstTime) {
      return IntroPage.routeName;
    } else {
      return LoginPage.routeName;
    }
  }

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        marginTitle:
            EdgeInsets.only(top: 100.0, left: 15.0, right: 15.0, bottom: 50.0),
        title: "Looking for a service or repair ?",
        styleTitle: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        description: "100+ services,repairs & products. We got it all !",
        marginDescription:
            EdgeInsets.symmetric(horizontal: 5.0, vertical: 70.0),
        styleDescription: TextStyle(
          color: Colors.blueGrey,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
        pathImage: "assets/images/car-breakdown.png",
        heightImage: 300,
        widthImage: 300,
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        marginTitle:
            EdgeInsets.only(top: 100.0, left: 15.0, right: 15.0, bottom: 50.0),
        title: "Book service or repair of choice",
        styleTitle: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        marginDescription:
            EdgeInsets.symmetric(horizontal: 5.0, vertical: 70.0),
        description: "60 seconds is all it takes to complete a booking !",
        styleDescription: TextStyle(
          color: Colors.blueGrey,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
        heightImage: 300,
        widthImage: 300,
        pathImage: "assets/images/crane.png",
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        marginTitle:
            EdgeInsets.only(top: 100.0, left: 15.0, right: 15.0, bottom: 50.0),
        title: "Real-time updates & assistance",
        styleTitle: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        marginDescription:
            EdgeInsets.symmetric(horizontal: 5.0, vertical: 70.0),
        description: "Dedicated advisor, genuine spares & warranty !",
        styleDescription: TextStyle(
          color: Colors.blueGrey,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
        heightImage: 300,
        widthImage: 300,
        pathImage: "assets/images/dashboard.png",
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        marginTitle:
            EdgeInsets.only(top: 100.0, left: 15.0, right: 15.0, bottom: 50.0),
        title: "Sit Back & Relax",
        styleTitle: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        marginDescription:
            EdgeInsets.symmetric(horizontal: 5.0, vertical: 70.0),
        description: "Free Pick-up & delivery and online payment !",
        styleDescription: TextStyle(
          color: Colors.blueGrey,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
        heightImage: 300,
        widthImage: 300,
        pathImage: "assets/images/car-1.png",
        backgroundColor: Colors.white,
      ),
    );
  }

  void onDonePress() {}

  void onSkipPress() {}

  Widget renderNextBtn() {
    return Text(
      "Next",
      style: TextStyle(fontSize: 20.0, color: Colors.white),
    );
  }

  Widget renderDoneBtn() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      },
      icon: Icon(Icons.done),
      color: Colors.white,
    );
  }

  Widget renderSkipBtn() {
    return Text(
      "Skip",
      style: TextStyle(fontSize: 20.0, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      onSkipPress: this.onSkipPress,
      colorSkipBtn: Colors.red,
      highlightColorSkipBtn: Colors.orangeAccent.withOpacity(0.5),

      // Next, Done button
      onDonePress: this.onDonePress,
      renderNextBtn: this.renderNextBtn(),
      renderDoneBtn: this.renderDoneBtn(),
      colorDoneBtn: Colors.red,
      highlightColorDoneBtn: Colors.orangeAccent.withOpacity(0.5),

      // Dot indicator
      colorDot: Colors.redAccent.withOpacity(0.5),
      colorActiveDot: Colors.red,
      sizeDot: 13.0,
    );
  }
}
