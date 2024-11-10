import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/controllers/question_controllers.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/app_colors.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  @override
  Widget build(BuildContext context) {
    QuestionControllers questionControllers = Get.put(QuestionControllers());
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          'assets/images/bg.svg',
          fit: BoxFit.fitWidth,
        ),
        Column(
          children: [
            const Spacer(
              flex: 3,
            ),
            Text(
              'Score:',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: AppColors.kScondaryColor),
            ),
            // const SizedBox(
            //   height: 20.0,
            // ),
            Text(
              // '${questionControllers.numOfCorrectAns} / ${questionControllers.question.length}',
              '${questionControllers.numOfCorrectAns} / ${questionControllers.filtredQuestion.length}',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: AppColors.kScondaryColor),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ],
    ));
  }
}
