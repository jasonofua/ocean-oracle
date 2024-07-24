
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPageOne extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 15),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 50,right: 50),
              child: Image.asset('assets/images/logogrey.png'),
            ),
            SizedBox(height: 50,),
            Text("Take a picture of the fish, you want to know about",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
            Expanded(child: Lottie.asset('assets/images/picture.json')),
          ],
        ),

      ),
    );
  }

}