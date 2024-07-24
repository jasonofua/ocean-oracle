import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ocean_oracle/Welcome/onboarding.dart';
import 'package:ocean_oracle/utils/constants.dart';
import 'package:ocean_oracle/utils/gemini_client.dart';
import 'package:overlay_support/overlay_support.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final geminiApiKey = 'AIzaSyC4alhoiwMeMgbVeHX8a9e_9mtVHxWjanU';
  final model = GenerativeModel(model: 'gemini-pro', apiKey: geminiApiKey);
  final gemini = GeminiClient(model: model);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: OverlaySupport.global(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Oracle Eyes',
          theme: ThemeData(
              primaryColor: kPrimaryColor,
              scaffoldBackgroundColor: Colors.white),
          home: OnboardingScreen(),
        ),
      ),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({required this.child}) : super(key: null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
