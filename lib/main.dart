import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/screens/welcome_screen/welcome_screen.dart';

import 'controllers/question_controllers.dart';

void main() {
  Get.put(QuestionControllers());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomeScreen(),
    );
  }
}
