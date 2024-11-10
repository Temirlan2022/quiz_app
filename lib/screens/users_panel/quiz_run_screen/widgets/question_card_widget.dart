import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/controllers/question_controllers.dart';
import 'package:quiz_app_with_getx/models/question_model.dart';
import 'package:quiz_app_with_getx/screens/admin_panel/options/option.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/app_colors.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/different_contants.dart';

class QuestionCardWidget extends StatelessWidget {
  final QuestionModel questionModel;

  const QuestionCardWidget({super.key, required this.questionModel});

  @override
  Widget build(BuildContext context) {
    // Получаем существующий экземпляр контроллера
    final QuestionControllers questionControllers =
        Get.find<QuestionControllers>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: padding15),
      padding: const EdgeInsets.all(padding15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: SingleChildScrollView(
        // Оборачиваем в SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionModel.question,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: AppColors.kBlackColor),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              questionModel.options.length,
              (index) => Options(
                text: questionModel.options[index],
                index: index,
                press: () => questionControllers.checkAnswer(
                  questionModel,
                  index,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
