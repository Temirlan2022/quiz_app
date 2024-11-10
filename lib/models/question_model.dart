class QuestionModel {
  final int id;
  final String question;
  final String category;
  final List<String> options;
  final int answer; // Индекс правильного ответа

  QuestionModel({
    required this.id,
    required this.question,
    required this.category,
    required this.options,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'category': category,
      'options': options,
      'answer': answer,
    };
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      question: json['question'],
      category: json['category'],
      options: List<String>.from(json['options']), // Преобразуем в List<String>
      answer: json['answer'], // Убедитесь, что это индекс
    );
  }
}
