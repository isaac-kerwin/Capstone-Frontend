class Question {
  final int id;
  final int questionId;
  final int eventId;
  final bool isRequired;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final QuestionDetails question;

  Question({
    required this.id,
    required this.questionId,
    required this.eventId,
    required this.isRequired,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.question,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json["id"],
      questionId: json["questionId"],
      eventId: json["eventId"],
      isRequired: json["isRequired"],
      displayOrder: json["displayOrder"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      question: QuestionDetails.fromJson(json["question"]),
    );
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
  final List<QuestionOption>? options;

  QuestionDetails(
      {required this.id,
      required this.questionText,
      required this.questionType,
      required this.category,
      required this.validationRules,
      required this.createdAt,
      required this.updatedAt,
      this.options});

  factory QuestionDetails.fromJson(Map<String, dynamic> json) {
    return QuestionDetails(
      id: json["id"],
      questionText: json["questionText"],
      questionType: json["questionType"],
      category: json["category"],
      validationRules: json["validationRules"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      options: json["options"] != null
          ? (json["options"] as List)
              .map((opt) => QuestionOption.fromJson(opt))
              .toList()
          : null,
    );
  }
}

class QuestionOption {
  final int id;
  final String optionText;
  final int? displayOrder;

  QuestionOption(
      {required this.id, required this.optionText, this.displayOrder});

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json["id"],
      optionText: json["optionText"],
      displayOrder: json["displayOrder"],
    );
  }
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
  final String questionType;
  final List<Map<String, dynamic>>? options;  // already correct

  CreateQuestionDTO({
    required this.questionText,
    required this.isRequired,
    required this.displayOrder,
    required this.questionType,
    this.options,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'questionText': questionText,
      'questionType': questionType,
      'options': options?.map((option) => {
        'optionText': option['optionText'],
        'displayOrder': option['displayOrder'],
      }).toList(),
      'isRequired': isRequired,
      'displayOrder': displayOrder,
    };
    return data;
  }
}


class QuestionDTO {
  final int id;
  final String questionText;
  final bool isRequired;
  final int displayOrder;
  final String questionType;
  final List<Map<String, dynamic>>? options;

  QuestionDTO({
    required this.id,
    required this.questionText,
    required this.isRequired,
    required this.displayOrder,
    required this.questionType,
    this.options,
  });

  factory QuestionDTO.fromJson(Map<String, dynamic> json) {
    return QuestionDTO(
      id: json["id"],
      questionText: json["questionText"],
      isRequired: json["isRequired"],
      displayOrder: json["displayOrder"],
      questionType: json["questionType"] ?? 'TEXT',
      options: (json["options"] as List<dynamic>?)
        ?.map((o) => Map<String, dynamic>.from(o as Map))
        .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "questionText": questionText,
      "isRequired": isRequired,
      "displayOrder": displayOrder,
      "questionType": questionType,
      if (options != null) 'options': options,
    };
  }
}
