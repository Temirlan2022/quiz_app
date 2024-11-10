import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/models/question_model.dart';
import '../../../controllers/question_controllers.dart';

class AdminScreen extends StatelessWidget {
  final String quizCategory;
  AdminScreen({super.key, required this.quizCategory});

  final QuestionControllers questionControllers = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add question to $quizCategory'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: questionControllers.questionController,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              for (var i = 0; i < 4; i++)
                TextFormField(
                  controller: questionControllers.optionControllers[i],
                  decoration: InputDecoration(labelText: 'Options ${i + 1}'),
                ),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(),
                controller: questionControllers.correctAnswerController,
                decoration:
                    const InputDecoration(labelText: 'Correct Answer (1 - 4)'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (questionControllers.questionController.text.isEmpty) {
                      Get.snackbar('Required', ' Все поля обезятельны');
                    } else if (questionControllers
                        .optionControllers[0].text.isEmpty) {
                      Get.snackbar('Required', ' Все поля обезятельны');
                    } else if (questionControllers
                        .optionControllers[1].text.isEmpty) {
                      Get.snackbar('Required', ' Все поля обезятельны');
                    } else if (questionControllers
                        .optionControllers[2].text.isEmpty) {
                      Get.snackbar('Required', ' Все поля обезятельны');
                    } else if (questionControllers
                        .optionControllers[3].text.isEmpty) {
                      Get.snackbar('Required', ' Все поля обезятельны');
                    } else if (questionControllers
                        .correctAnswerController.text.isEmpty) {
                      Get.snackbar('Required', ' Все поля обезятельны');
                    } else {
                      addQuestion();
                    }
                  },
                  child: const Text('Add Question'))
            ],
          ),
        ),
      ),
    );
  }

  void addQuestion() async {
    final String questionText = questionControllers.questionController.text;
    final List<String> options = questionControllers.optionControllers
        .map((controller) => controller.text)
        .toList();
    final int correctAnswer =
        int.tryParse(questionControllers.correctAnswerController.text) ?? 1;
    //создание нового вопроса
    final QuestionModel newQuestion = QuestionModel(
        id: DateTime.now().microsecondsSinceEpoch,
        question: questionText,
        category: quizCategory,
        options: options,
        answer: correctAnswer - 1);

    //сохранение вопроса на SharedPreferences
    await questionControllers.saveQuestionToSharedPreferences(newQuestion);

    Get.snackbar('Добавлен', 'Вопрос добавлен');

    questionControllers.questionController.clear();
    questionControllers.correctAnswerController.clear();
    questionControllers.optionControllers.forEach((element) {
      element.clear();
    });
  }
}
