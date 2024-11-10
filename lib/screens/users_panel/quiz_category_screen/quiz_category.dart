import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/controllers/question_controllers.dart';

import '../quiz_run_screen/quiz_screen.dart';

class QuizCategoryScreen extends StatelessWidget {
  QuizCategoryScreen({super.key});

  final QuestionControllers _questionControllers =
      Get.put(QuestionControllers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/images/bg.svg',
            fit: BoxFit.fitWidth,
          ),
          Obx(
            () => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: _questionControllers.savedCategories.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        () => QuizScreen(
                          category: _questionControllers.savedCategories[index],
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.question_answer),
                        Text(_questionControllers.savedCategories[index]),
                        Text(_questionControllers.savedSubtitle[index])
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
