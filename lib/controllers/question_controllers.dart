import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_getx/models/question_model.dart';
import 'package:quiz_app_with_getx/screens/users_panel/score_screen/score_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionControllers extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController
      _animationController; // Контроллер анимации для управления анимациями
  late Animation<double>
      _animation; // Анимация, которая будет использоваться для таймера
  Animation<double> get animation => _animation; // Геттер для анимации

  // UI-код
  late PageController
      _pageController; // Контроллер страницы для навигации между вопросами
  PageController get pageController =>
      _pageController; // Геттер для контроллера страницы
  bool _isAnswered = false; // Переменная, показывающая, был ли выбран ответ
  bool get isAnswered =>
      _isAnswered; // Геттер для проверки, был ли выбран ответ

  int _correctAns = 0; // Переменная для хранения правильного ответа
  int get correctAns => _correctAns; // Геттер для получения правильного ответа

  int _selectedAns = 0; // Переменная для хранения выбранного ответа
  int get selectedAns => _selectedAns; // Геттер для получения выбранного ответа

  int _numOfCorrectAns = 0; // Переменная для подсчета числа правильных ответов
  int get numOfCorrectAns =>
      _numOfCorrectAns; // Геттер для получения числа правильных ответов

  final RxInt _questionNumber = 1
      .obs; // Переменная для хранения номера текущего вопроса, оборачиваем в Rx для реактивного обновления
  RxInt get questionNumber =>
      _questionNumber; // Геттер для номера текущего вопроса

  // Код для панели администратора
  List<QuestionModel> _question =
      []; // Список вопросов, загруженных из SharedPreferences
  List<QuestionModel> get question =>
      _question; // Геттер для получения списка вопросов

  List<QuestionModel> _filtredQuestion =
      []; // Список фильтрованных вопросов по категории
  List<QuestionModel> get filtredQuestion =>
      _filtredQuestion; // Геттер для получения фильтрованных вопросов
  final TextEditingController questionController =
      TextEditingController(); // Контроллер для поля ввода вопроса
  final List<TextEditingController> optionControllers = List.generate(
      4,
      (index) =>
          TextEditingController()); // Контроллеры для полей ввода вариантов ответов
  final TextEditingController correctAnswerController =
      TextEditingController(); // Контроллер для поля ввода правильного ответа
  final TextEditingController quizCategory =
      TextEditingController(); // Контроллер для поля ввода категории викторины

  // Сохраняем вопрос в SharedPreferences
  Future<void> saveQuestionToSharedPreferences(QuestionModel question) async {
    final prefs = await SharedPreferences
        .getInstance(); // Получаем экземпляр SharedPreferences
    final questions = prefs.getStringList('questions') ??
        []; // Получаем список вопросов из SharedPreferences, если нет - создаем новый список

    // Конвертируем вопрос в JSON и добавляем в список
    questions
        .add(jsonEncode(question.toJson())); // Добавляем новый вопрос в список
    await prefs.setStringList(
        'questions', questions); // Сохраняем обновленный список вопросов
    print(
        "Saved questions: ${prefs.getStringList('questions')}"); // Выводим сохраненные вопросы в консоль
  }

  // Административная панель
  final String _categoryKey =
      "category_title"; // Ключ для хранения категорий вопросов
  final String _subtitleKey = "subtitle"; // Ключ для хранения подкатегорий
  TextEditingController categoryTitleController =
      TextEditingController(); // Контроллер для ввода заголовка категории
  TextEditingController categorySubtitleController =
      TextEditingController(); // Контроллер для ввода подкатегории

  RxList<String> savedCategories =
      <String>[].obs; // Реактивный список для хранения категорий
  RxList<String> savedSubtitle =
      <String>[].obs; // Реактивный список для хранения подкатегорий

  // Сохраняем категорию вопроса в SharedPreferences
  void savedQuestionCategoryToSharedPreferences() async {
    if (categoryTitleController.text.isNotEmpty &&
        categorySubtitleController.text.isNotEmpty) {
      // Проверяем, что оба поля не пустые
      final prefs = await SharedPreferences
          .getInstance(); // Получаем экземпляр SharedPreferences

      savedCategories
          .add(categoryTitleController.text); // Добавляем категорию в список
      savedSubtitle.add(
          categorySubtitleController.text); // Добавляем подкатегорию в список

      await prefs.setStringList(
          _categoryKey, savedCategories.toList()); // Сохраняем список категорий
      await prefs.setStringList(_subtitleKey,
          savedSubtitle.toList()); // Сохраняем список подкатегорий

      print(
          "Saved categories: ${prefs.getStringList(_categoryKey)}"); // Выводим сохраненные категории
      print(
          "Saved subtitles: ${prefs.getStringList(_subtitleKey)}"); // Выводим сохраненные подкатегории

      categorySubtitleController.clear(); // Очищаем поле ввода подкатегории
      categoryTitleController.clear(); // Очищаем поле ввода категории

      // Отложенное обновление UI, чтобы избежать изменения дерева виджетов во время сборки
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Saved',
            "Category created successfully"); // Показываем уведомление о сохранении
        update(); // Обновляем состояние
      });
    } else {
      Get.snackbar('Error',
          'Both fields must be filled'); // Если одно из полей пустое, показываем ошибку
    }
  }

  // Удаляем категорию из SharedPreferences
  void deleteSavedCategoriesFromSharedPreferences(int index) async {
    final prefs = await SharedPreferences
        .getInstance(); // Получаем экземпляр SharedPreferences

    // Загружаем списки категорий и подкатегорий из SharedPreferences
    List<String> savedCategories = prefs.getStringList(_categoryKey) ?? [];
    List<String> savedSubtitles = prefs.getStringList(_subtitleKey) ?? [];

    // Удаляем элементы по индексу
    if (index >= 0 && index < savedCategories.length) {
      savedCategories.removeAt(index); // Удаляем категорию по индексу
      savedSubtitles.removeAt(index); // Удаляем подкатегорию по индексу

      // Обновляем SharedPreferences
      await prefs.setStringList(_categoryKey, savedCategories);
      await prefs.setStringList(_subtitleKey, savedSubtitles);

      // Обновляем локальные переменные контроллера
      this.savedCategories.assignAll(savedCategories);
      this.savedSubtitle.assignAll(savedSubtitles);

      print(
          "Category deleted. Remaining categories: ${prefs.getStringList(_categoryKey)}"); // Выводим оставшиеся категории

      // Показываем уведомление
      Get.snackbar('Deleted', "Category has been deleted successfully");
    } else {
      Get.snackbar('Error',
          "Category not found"); // Если категория не найдена, показываем ошибку
    }

    // Обновляем состояние
    update();
  }

  // Обновляем номер текущего вопроса
  void updateTheQNum(int index) {
    _questionNumber.value = index + 1; // Устанавливаем новый номер вопроса
    update(); // Обновляем состояние
  }

  // Фильтруем вопросы по категории
  void setFilteredQuestions(String category, bool nextQuestionBool) {
    _filtredQuestion =
        getQuestionByCategory(category); // Фильтруем вопросы по категории
    _questionNumber.value = 1; // Сбрасываем номер вопроса
    update(); // Обновляем состояние
    if (nextQuestionBool == true) {
      nextQuestion(); // Переходим к следующему вопросу, если нужно
    }
  }

  @override
  void onInit() {
    super.onInit(); // Инициализация родительского класса
    loadQestionCategoryFromSharePreferences(); // Загружаем категории из SharedPreferences
    loadQuestionsFromSharedPreferences(); // Загружаем вопросы из SharedPreferences
    _pageController = PageController(); // Инициализируем контроллер страницы
    _animationController = AnimationController(
        vsync: this,
        duration:
            const Duration(seconds: 60)); // Инициализируем контроллер анимации
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(_animationController) // Устанавливаем анимацию
      ..addListener(() {
        update(); // Обновляем состояние при изменении анимации
      });

    update(); // Обновляем состояние
  }

  // Стартуем таймер
  void startTimer() {
    _animationController.forward().whenComplete(
        nextQuestion); // Запускаем анимацию и переходим к следующему вопросу
  }

  // Загружаем категории вопросов из SharedPreferences
  void loadQestionCategoryFromSharePreferences() async {
    final prefs = await SharedPreferences
        .getInstance(); // Получаем экземпляр SharedPreferences
    final categories =
        prefs.getStringList(_categoryKey) ?? []; // Загружаем список категорий
    final subtitles = prefs.getStringList(_subtitleKey) ??
        []; // Загружаем список подкатегорий

    print("Categories loaded: $categories"); // Выводим загруженные категории
    print("Subtitles loaded: $subtitles"); // Выводим загруженные подкатегории

    savedCategories
        .assignAll(categories); // Обновляем локальный список категорий
    savedSubtitle
        .assignAll(subtitles); // Обновляем локальный список подкатегорий
    update(); // Обновляем состояние
  }

  // Загружаем вопросы из SharedPreferences
  void loadQuestionsFromSharedPreferences() async {
    final prefs = await SharedPreferences
        .getInstance(); // Получаем экземпляр SharedPreferences
    final questionJson = prefs.getStringList("questions") ??
        []; // Загружаем список вопросов в формате JSON

    _question = questionJson
        .map((json) => QuestionModel.fromJson(
            jsonDecode(json))) // Декодируем каждый вопрос
        .toList(); // Преобразуем в список объектов QuestionModel
    print("Loaded questions: $_question"); // Выводим загруженные вопросы

    update(); // Обновляем состояние
  }

  // Удаляем вопрос из SharedPreferences
  Future<void> deleteQuestionFromSharedPreferences(int index) async {
    final prefs = await SharedPreferences
        .getInstance(); // Получаем экземпляр SharedPreferences
    final questions =
        prefs.getStringList('questions') ?? []; // Загружаем список вопросов

    if (index >= 0 && index < questions.length) {
      // Если индекс в пределах списка
      questions.removeAt(index); // Удаляем вопрос по индексу
      await prefs.setStringList(
          'questions', questions); // Сохраняем обновленный список вопросов

      // Опционально, обновляем фильтрованный список или внутреннее состояние
      filtredQuestion
          .removeAt(index); // Убираем вопрос из фильтрованного списка

      print(
          "Question deleted, updated list: $questions"); // Выводим обновленный список вопросов
    }
  }

  // Получаем вопросы по категории
  List<QuestionModel> getQuestionByCategory(String category) {
    return _question
        .where((question) =>
            question.category == category) // Фильтруем вопросы по категории
        .toList();
  }

  // Проверяем правильность ответа
  void checkAnswer(QuestionModel question, int selectedIndex) {
    _isAnswered = true; // Устанавливаем, что ответ был выбран
    _correctAns = question.answer; // Сохраняем правильный ответ
    _selectedAns = selectedIndex; // Сохраняем выбранный ответ

    if (_correctAns == _selectedAns) // Если выбранный ответ правильный
      _numOfCorrectAns++; // Увеличиваем счетчик правильных ответов
    _animationController.stop(); // Останавливаем анимацию
    update(); // Обновляем состояние

    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion(); // Переходим к следующему вопросу через 1 секунду
    });
  }

  // Переход к следующему вопросу
  void nextQuestion() async {
    if (_questionNumber.value < _filtredQuestion.length) {
      // Если есть еще вопросы
      _isAnswered = false; // Сбрасываем флаг ответа
      _pageController.nextPage(
        duration: const Duration(microseconds: 250),
        curve: Curves.ease,
      ); // Переходим на следующую страницу

      _animationController.reset(); // Сбрасываем анимацию
      _animationController.forward().whenComplete(
          nextQuestion); // Запускаем анимацию и переходим к следующему вопросу
    } else {
      Get.to(() =>
          const ScoreScreen()); // Если вопросов больше нет, переходим на экран с результатами
    }
  }
}
