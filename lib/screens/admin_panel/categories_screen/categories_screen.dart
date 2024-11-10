import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/controllers/question_controllers.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/different_contants.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/text_styles.dart';
import '../questions_screeen/questions_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final QuestionControllers questionControllers =
      Get.put(QuestionControllers());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: GetBuilder<QuestionControllers>(
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.savedCategories.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    Get.to(
                      () => QuestionsScreen(
                        category: controller.savedCategories[index],
                      ),
                    );
                  },
                  leading: const Icon(Icons.question_answer),
                  title: Text(controller.savedCategories[index]),
                  subtitle: Text(controller.savedSubtitle[index]),
                  trailing: IconButton(
                    onPressed: () => _removeCategoriesShowDialog(index),
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 80,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: _addCategoriesShowDialog,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Add category',
                style: TextStyles.inter10,
                textAlign: TextAlign.center,
              )
            ]),
          ),
        ),
      ),
    );
  }

  _addCategoriesShowDialog() {
    Get.defaultDialog(
        titlePadding: const EdgeInsets.only(top: padding15),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: padding25, vertical: padding25),
        title: 'Add category',
        content: Column(
          children: [
            TextFormField(
              controller: questionControllers.categoryTitleController,
              decoration: const InputDecoration(
                hintText: "Enter the category name",
              ),
            ),
            TextFormField(
              controller: questionControllers.categorySubtitleController,
              decoration: const InputDecoration(
                hintText: "Enter the category subtitle",
              ),
            ),
          ],
        ),
        textConfirm: "Create",
        textCancel: "Cancel",
        onConfirm: () {
          questionControllers.savedQuestionCategoryToSharedPreferences();
          Get.back();
          print(questionControllers.savedCategories);
        });
  }

  void _removeCategoriesShowDialog(int index) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 15.0),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
      title: 'Delete Quiz category',
      content: const Column(
        children: [
          Text(
            'Вы уверены что хотите удалить эту категорию?',
            textAlign: TextAlign.center,
          )
        ],
      ),
      textConfirm: "Delete",
      textCancel: "Cancel",
      onConfirm: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          questionControllers.deleteSavedCategoriesFromSharedPreferences(index);
          Get.back();
          print(questionControllers.savedCategories);
        });
      },
    );
  }
}
