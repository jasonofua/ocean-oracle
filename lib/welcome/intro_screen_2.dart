
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPageTwo extends StatelessWidget{
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
            Text("Get all the information about the fish",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            Expanded(child: Lottie.asset('assets/images/fish.json')),
          ],
        ),

      ),
    );
  }

}