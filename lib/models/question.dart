class Question {
  final int id;
  final int eventId;
  final bool isRequired;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final QuestionDetails question;

  Question(
      {required this.id,
      required this.eventId,
      required this.isRequired,
      required this.displayOrder,
      required this.createdAt,
      required this.updatedAt,
      required this.question});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        id: json["id"],
        eventId: json["eventId"],
        isRequired: json["isRequired"],
        displayOrder: json["displayOrder"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        question: QuestionDetails(
            id: json["question"]["id"],
            questionText: json["question"]["questionText"],
            questionType: json["question"]["questionType"],
            category: json["question"]["category"],
            validationRules: json["question"]["validationRules"],
            createdAt: DateTime.parse(json["question"]["createdAt"]),
            updatedAt: DateTime.parse(json["question"]["updatedAt"])));
  }
}

class QuestionDetails {
  final int id;
  final String questionText;
  final String questionType;
  final String? category;
  final String? validationRules;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuestionDetails(
      {required this.id,
      required this.questionText,
      required this.questionType,
      required this.category,
      required this.validationRules,
      required this.createdAt,
      required this.updatedAt});
}

class QuestionGroup {
  final List<Question> questions;

  QuestionGroup({
    required this.questions,
  });

  factory QuestionGroup.fromJson(Map<String, dynamic> json) {
    return QuestionGroup(
        questions: (json["questions"] as List)
            .map((question) => Question.fromJson(question))
            .toList());
  }
}



class CreateQuestionDTO {
  final String questionText;
  final bool isRequired;
  final int displayOrder;

  CreateQuestionDTO(
      {required this.questionText,
      required this.isRequired,
      required this.displayOrder});

  Map<String, dynamic> toJson() {
    return {
      "questionText": questionText,
      "isRequired": isRequired,
      "displayOrder": displayOrder
    };
  }
}
