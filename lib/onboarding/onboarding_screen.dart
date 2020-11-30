import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Eserve/onboarding/pages/first_page.dart';
import 'package:Eserve/onboarding/pages/login_page.dart';
import 'package:Eserve/onboarding/pages/second_page.dart';
import 'package:Eserve/onboarding/pages/third_page.dart';
import 'package:page_indicator/page_indicator.dart';

class OnBoardingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    List<Image> icons = List<Image>();
    icons.add(Image.asset("images/scissor_icon.png"));
    icons.add(Image.asset(
      "images/massage_icon.png",
      width: 140,
    ));
    icons.add(Image.asset("images/shave_icon.png"));

    List<String> backgroundImages = List<String>();
    backgroundImages.add("images/haircut.jpg");
    backgroundImages.add("images/massage_pic.jpg");
    backgroundImages.add("images/shaving_pic.png");
    backgroundImages.add("images/salon_shop.png");

    final myController = PageController(
      initialPage: 0,
    );
    PageView pageView = PageView(
      controller: myController,
      children: <Widget>[
        MyFirstPage("Need a Mechanic?", icons[0], backgroundImages[0],
            "Find Near by \nMechanics"),
        MySecondPage("Need a Carpenter?", icons[1], backgroundImages[1],
            "Find Near by \nCarpenter"),
        MyThirdPage("Need any other Professional", icons[2],
            backgroundImages[2], "All will be \nAvailable here"),
        MyLoginPage("Need an Appointment?", backgroundImages[3],
            "Find Near by \nall Professionals"),
      ],
      physics: BouncingScrollPhysics(),
    );
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(children: <Widget>[
        PageIndicatorContainer(
          pageView: pageView,
          length: 4,
          indicatorSpace: 10.0,
          indicatorSelectorColor: Color(0xFFf15e5e),
        ),
      ]),
    );
  }
}
