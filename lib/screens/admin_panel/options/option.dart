import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/controllers/question_controllers.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/app_colors.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/different_contants.dart';

class Options extends StatelessWidget {
  final String text;
  final int index;
  final VoidCallback press;

  const Options({
    super.key,
    required this.text,
    required this.index,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionControllers>(
      builder: (controller) {
        Color getTheRightColor() {
          if (controller.isAnswered) {
            if (index == controller.correctAns) {
              return AppColors.kGreenColor; // Правильный ответ
            } else if (index == controller.selectedAns &&
                controller.selectedAns != controller.correctAns) {
              return AppColors.kRedColor; // Неправильный ответ
            }
          }
          return AppColors.kGrayColor; // Не выбранный ответ
        }

        IconData getTheRightIcon() {
          if (getTheRightColor() == AppColors.kGreenColor) {
            return Icons.done; // Иконка для правильного ответа
          } else if (getTheRightColor() == AppColors.kRedColor) {
            return Icons.close; // Иконка для неправильного ответа
          }
          return Icons.circle; // Иконка для невыбранного ответа
        }

        return GestureDetector(
          onTap: press,
          child: Container(
            margin: const EdgeInsets.only(top: padding15),
            padding: const EdgeInsets.all(padding15),
            decoration: BoxDecoration(
              border: Border.all(
                color: getTheRightColor(),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Text(
                  "${index + 1}.$text",
                  style: TextStyle(
                    color: getTheRightColor(),
                    fontSize: 16,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: getTheRightColor() == AppColors.kGrayColor
                        ? AppColors.transparent
                        : getTheRightColor(),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: getTheRightColor(),
                    ),
                  ),
                  child: getTheRightColor() == AppColors.kGrayColor
                      ? null
                      : Icon(
                          getTheRightIcon(),
                          size: 16,
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
