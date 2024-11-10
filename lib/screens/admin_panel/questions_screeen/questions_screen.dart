import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/controllers/question_controllers.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/text_styles.dart';

import '../add_question_screen/add_question_screen.dart';

class QuestionsScreen extends StatefulWidget {
  final String category;

  const QuestionsScreen({super.key, required this.category});
  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final QuestionControllers questionControllers =
      Get.put(QuestionControllers());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      questionControllers.setFilteredQuestions(widget.category, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
      ),
      body: GetBuilder<QuestionControllers>(
        builder: (controller) {
          return questionControllers.question.length > 0
              ? ListView.builder(
                  itemCount: controller.filtredQuestion.length,
                  itemBuilder: (context, index) {
                    final question = controller.filtredQuestion[index];
                    return Card(
                      child: ListTile(
                        title: Text(question.question),
                        subtitle: Text("Category: ${question.category}"),
                        trailing: IconButton(
                          onPressed: () {
                            _removeQuestionShowDialog(index);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    );
                  },
                )
              : const Center(child: Text('Эта категория пустая'));
        },
      ),
      floatingActionButton: SizedBox(
        width: 80,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              // Add a new question
              Get.to(() => AdminScreen(quizCategory: widget.category));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add questions',
                  style: TextStyles.inter10,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _removeQuestionShowDialog(int index) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 15.0),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
      title: 'Delete Question',
      content: const Column(
        children: [
          Text(
            'Are you sure you want to delete this question?',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      textConfirm: "Delete",
      textCancel: "Cancel",
      onConfirm: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          questionControllers.deleteQuestionFromSharedPreferences(index);
          Get.back();
          print(
              'Question deleted, remaining: ${questionControllers.filtredQuestion.length}');
        });
      },
    );
    setState(() {});
  }
}
