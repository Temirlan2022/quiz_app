import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/controllers/question_controllers.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/app_colors.dart';
import 'widgets/quiz_run_widget.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({required this.category, super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuestionControllers questionControllers = Get.put(QuestionControllers());
  @override
  void initState() {
    questionControllers.setFilteredQuestions(widget.category, true);
    questionControllers.startTimer();
    super.initState();
  }
  // @override
  // void initState() {
  //   super.initState();
  //   // Отложенный запуск, чтобы гарантировать, что все виджеты были построены
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // Фильтруем вопросы по категории
  //     questionControllers.setFilteredQuestions(
  //         widget.category, true); // No 'await'
  //     // Запускаем таймер после того, как вопросы фильтруются
  //     questionControllers.startTimer();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparent,
        actions: [
          TextButton(
            onPressed: questionControllers.nextQuestion,
            child: const Text('Skip'),
          )
        ],
      ),
      body: const QuizRunWidget(),
    );
  }
}
