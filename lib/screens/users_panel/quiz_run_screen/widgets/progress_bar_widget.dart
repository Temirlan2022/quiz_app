import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/controllers/question_controllers.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/app_colors.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/different_contants.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.progressBorder, width: 3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: GetBuilder(
        init: QuestionControllers(),
        builder: (controller) {
          return Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * controller.animation.value,
                    decoration: BoxDecoration(
                      gradient: AppColors.kPrimaryGradient,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  );
                },
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding15 / 2),
                  child: Row(
                    children: [
                      Text("${(controller.animation.value * 60).round()}")
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
