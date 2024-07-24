import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ocean_oracle/welcome/intro_screen_1.dart';
import 'package:ocean_oracle/welcome/intro_screen_2.dart';
import 'package:ocean_oracle/welcome/intro_screen_3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();

  bool lastPage = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PageView(
              onPageChanged: (value){
                setState(() {
                  lastPage = (value == 2);
                });
              },
              controller: _pageController,
              children: [IntroPageOne(), IntroPageTwo(), IntroPageThree()],
            ),
            Container(
                alignment: Alignment(0, 0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(onTap: () {
                      _pageController.jumpToPage(2);
                      }, child: Text('Skip')),
                    SmoothPageIndicator(controller: _pageController, count: 3),
                    lastPage?GestureDetector(
                      onTap: (){
                        // _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      },
                        child: Text('Done')):GestureDetector(
                        onTap: (){
                          _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                        },
                        child: Text('Next')),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
