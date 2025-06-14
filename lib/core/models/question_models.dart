/// Defines models for event questions, details, options, and DTOs for creation, updating, and transfer.

/// Represents a question instance within an event, with metadata and details.
class Question {
  /// Unique record identifier.
  final int id;
  /// Identifier for the question definition.
  final int questionId;
  /// Identifier of the event associated with this question.
  final int eventId;
  /// Whether the question is mandatory.
  final bool isRequired;
  /// Display order index for the question.
  final int displayOrder;
  /// Creation timestamp.
  final DateTime createdAt;
  /// Last update timestamp.
  final DateTime updatedAt;
  /// Detailed question definition.
  final QuestionDetails question;

  /// Constructs a [Question] record.
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

  /// Creates a [Question] from JSON data.
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

/// Detailed definition of a question, including text, type, and options.
class QuestionDetails {
  /// Unique question identifier.
  final int id;
  /// Text content of the question.
  final String questionText;
  /// Type of the question (e.g., TEXT, MULTIPLE_CHOICE).
  final String questionType;
  /// Optional category grouping.
  final String? category;
  /// Optional validation rules as JSON string.
  final String? validationRules;
  /// Creation timestamp.
  final DateTime createdAt;
  /// Update timestamp.
  final DateTime updatedAt;
  /// List of possible options for choice questions.
  final List<QuestionOption>? options;

  /// Constructs a [QuestionDetails].
  QuestionDetails({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.category,
    required this.validationRules,
    required this.createdAt,
    required this.updatedAt,
    this.options,
  });

  /// Creates a [QuestionDetails] from JSON.
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

/// Represents an option for multiple-choice or selection questions.
class QuestionOption {
  /// Unique option identifier.
  final int id;
  /// Text to display for this option.
  final String optionText;
  /// Optional display order for the option.
  final int? displayOrder;

  /// Constructs a [QuestionOption].
  QuestionOption({
    required this.id,
    required this.optionText,
    this.displayOrder,
  });

  /// Creates a [QuestionOption] from JSON data.
  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json["id"],
      optionText: json["optionText"],
      displayOrder: json["displayOrder"],
    );
  }
}

/// Group of related questions.
class QuestionGroup {
  /// List of questions in this group.
  final List<Question> questions;

  /// Constructs a [QuestionGroup].
  QuestionGroup({required this.questions});

  /// Creates a [QuestionGroup] from JSON.
  factory QuestionGroup.fromJson(Map<String, dynamic> json) {
    return QuestionGroup(
        questions: (json["questions"] as List)
            .map((question) => Question.fromJson(question))
            .toList());
  }
}

/// DTO for creating new questions in an event.
class CreateQuestionDTO {
  /// Text content of the new question.
  final String questionText;
  /// Whether the question is required.
  final bool isRequired;
  /// Display order index.
  final int displayOrder;
  /// Type of the question.
  final String questionType;
  /// List of options for choice questions, each with text and order.
  final List<Map<String, dynamic>>? options;

  /// Constructs a [CreateQuestionDTO].
  CreateQuestionDTO({
    required this.questionText,
    required this.isRequired,
    required this.displayOrder,
    required this.questionType,
    this.options,
  });

  /// Serializes the DTO to JSON for API submission.
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

/// DTO representing an existing question for updates or transfers.
class QuestionDTO {
  /// Unique question identifier.
  final int id;
  /// Text of the question.
  final String questionText;
  /// Whether question is required.
  final bool isRequired;
  /// Display index.
  final int displayOrder;
  /// Type of question.
  final String questionType;
  /// Optional list of options.
  final List<Map<String, dynamic>>? options;

  /// Constructs a [QuestionDTO].
  QuestionDTO({
    required this.id,
    required this.questionText,
    required this.isRequired,
    required this.displayOrder,
    required this.questionType,
    this.options,
  });

  /// Creates a [QuestionDTO] from JSON.
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

  /// Serializes the DTO to JSON.
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

/// DTO for updating question metadata (order, required flag).
class UpdateQuestionDTO {
  /// Optional new required flag.
  final bool? isRequired;
  /// Optional new display order.
  final int? displayOrder;

  /// Constructs an [UpdateQuestionDTO].
  UpdateQuestionDTO({this.isRequired, this.displayOrder});

  /// Serializes non-null fields to JSON for partial updates.
  Map<String, dynamic> toJson() {
    return {
      if (isRequired != null) "isRequired": isRequired,
      if (displayOrder != null) "displayOrder": displayOrder,
    };
  }
}
