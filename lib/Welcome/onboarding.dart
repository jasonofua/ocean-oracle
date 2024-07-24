import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget{

  const OnboardingScreen({Key? key}):super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();

}

class _OnboardingScreenState extends State<OnboardingScreen>{

  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     body: Container(
       child: Stack(
         children: [
           PageView(
             children: [
               Container(
                 color: Colors.blue,
               ),
               Container(
                 color: Colors.red,
               ),
               Container(
                 color: Colors.yellow,
               ),
             ],
           ),
           SmoothPageIndicator(controller: _pageController, count: 3)
         ],
       ),
     ),
   );
  }

}