import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/screens/users_panel/quiz_run_screen/widgets/progress_bar_widget.dart';
import 'package:quiz_app_with_getx/screens/users_panel/quiz_run_screen/widgets/question_card_widget.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/app_colors.dart';
import '../../../../controllers/question_controllers.dart';

class QuizRunWidget extends StatelessWidget {
  const QuizRunWidget({super.key});

  @override
  Widget build(BuildContext context) {
    QuestionControllers questionControllers = Get.find();

    PageController pageController = questionControllers.pageController;
    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          'assets/images/bg.svg',
          fit: BoxFit.fitWidth,
        ),
        SafeArea(
          child: Column(
            children: [
              const ProgressBarWidget(),
              Obx(
                () => Text.rich(
                  TextSpan(
                    text:
                        "Question ${questionControllers.questionNumber.value}",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: AppColors.kScondaryColor,
                        ),
                    children: [
                      TextSpan(
                        // text: "/${questionControllers.question.length}",
                        text: "/${questionControllers.filtredQuestion.length}",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: AppColors.kScondaryColor,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 1.5,
              ),
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: questionControllers.updateTheQNum,
                  itemCount: questionControllers.filtredQuestion.length,
                  controller: pageController,
                  itemBuilder: (context, index) {
                    return QuestionCardWidget(
                      questionModel: questionControllers.filtredQuestion[index],
                      // questionModel: questionControllers.question[index],
                    );
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
