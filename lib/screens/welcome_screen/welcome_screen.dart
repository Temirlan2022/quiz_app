import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/screens/admin_panel/categories_screen/categories_screen.dart';
import 'package:quiz_app_with_getx/screens/users_panel/quiz_category_screen/quiz_category.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/app_colors.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/different_contants.dart';
import 'package:quiz_app_with_getx/screens/utils/constants/text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  WelcomeScreen({super.key});
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: padding20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(
                    flex: 1,
                  ),
                  Text(
                    "Let's play Quiz",
                    style: TextStyles.inter24bold,
                  ),
                  const Text("Enter your information below"),
                  const Spacer(),
                  SizedBox(
                    child: Column(
                      children: [
                        TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.kGrayColor2,
                            hintText: "Full Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            final username = usernameController.text;
                            if (username == 'Admin' || username == 'admin') {
                              Get.to(() => const AdminDashboard());
                            } else {
                              Get.to(() => QuizCategoryScreen());
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(padding15),
                            decoration: const BoxDecoration(
                                gradient: AppColors.kPrimaryGradient,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0))),
                            child: Text(
                              "Let's Start",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: AppColors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
