/// Assessment entity.
class Assessment {
  final String id;
  final String organizationId;
  final String branchId;
  final String? classId;
  final String teacherId;
  final String title;
  final String? description;
  final AssessmentType type;
  final double maxScore;
  final double passingScore;
  final DateTime assessmentDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Assessment({
    required this.id,
    required this.organizationId,
    required this.branchId,
    this.classId,
    required this.teacherId,
    required this.title,
    this.description,
    this.type = AssessmentType.exam,
    this.maxScore = 100,
    this.passingScore = 50,
    required this.assessmentDate,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      classId: json['class_id'] as String?,
      teacherId: json['teacher_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: AssessmentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AssessmentType.exam,
      ),
      maxScore: (json['max_score'] as num?)?.toDouble() ?? 100,
      passingScore: (json['passing_score'] as num?)?.toDouble() ?? 50,
      assessmentDate: DateTime.parse(json['assessment_date'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'branch_id': branchId,
      'class_id': classId,
      'teacher_id': teacherId,
      'title': title,
      'description': description,
      'type': type.name,
      'max_score': maxScore,
      'passing_score': passingScore,
      'assessment_date': assessmentDate.toIso8601String().split('T')[0],
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Assessment copyWith({
    String? id,
    String? organizationId,
    String? branchId,
    String? classId,
    String? teacherId,
    String? title,
    String? description,
    AssessmentType? type,
    double? maxScore,
    double? passingScore,
    DateTime? assessmentDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Assessment(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      branchId: branchId ?? this.branchId,
      classId: classId ?? this.classId,
      teacherId: teacherId ?? this.teacherId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      maxScore: maxScore ?? this.maxScore,
      passingScore: passingScore ?? this.passingScore,
      assessmentDate: assessmentDate ?? this.assessmentDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Assessment result entity.
class AssessmentResult {
  final String id;
  final String assessmentId;
  final String studentId;
  final double? score;
  final AssessmentResultType? result;
  final String? teacherNotes;
  final DateTime recordedAt;
  final DateTime createdAt;

  const AssessmentResult({
    required this.id,
    required this.assessmentId,
    required this.studentId,
    this.score,
    this.result,
    this.teacherNotes,
    required this.recordedAt,
    required this.createdAt,
  });

  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      id: json['id'] as String,
      assessmentId: json['assessment_id'] as String,
      studentId: json['student_id'] as String,
      score: (json['score'] as num?)?.toDouble(),
      result: json['result'] != null
          ? AssessmentResultType.values.firstWhere(
              (e) => e.name == json['result'],
              orElse: () => AssessmentResultType.good,
            )
          : null,
      teacherNotes: json['teacher_notes'] as String?,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assessment_id': assessmentId,
      'student_id': studentId,
      'score': score,
      'result': result?.name,
      'teacher_notes': teacherNotes,
      'recorded_at': recordedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Assessment type enum.
enum AssessmentType {
  quiz,
  exam,
  memorization,
  tajwid,
  reading,
  participation,
}

/// Assessment result type enum.
enum AssessmentResultType {
  excellent,
  veryGood,
  good,
  acceptable,
  weak,
  fail,
}

/// Extension for display names.
extension AssessmentTypeExtension on AssessmentType {
  String get displayName {
    return switch (this) {
      AssessmentType.quiz => 'Quiz',
      AssessmentType.exam => 'Exam',
      AssessmentType.memorization => 'Memorization',
      AssessmentType.tajwid => 'Tajwid',
      AssessmentType.reading => 'Reading',
      AssessmentType.participation => 'Participation',
    };
  }

  String get displayNameAr {
    return switch (this) {
      AssessmentType.quiz => 'اختبار قصير',
      AssessmentType.exam => 'امتحان',
      AssessmentType.memorization => 'تقييم حفظ',
      AssessmentType.tajwid => 'تقييم تجويد',
      AssessmentType.reading => 'تقييم قراءة',
      AssessmentType.participation => 'مشاركة',
    };
  }
}

extension AssessmentResultTypeExtension on AssessmentResultType {
  String get displayName {
    return switch (this) {
      AssessmentResultType.excellent => 'Excellent',
      AssessmentResultType.veryGood => 'Very Good',
      AssessmentResultType.good => 'Good',
      AssessmentResultType.acceptable => 'Acceptable',
      AssessmentResultType.weak => 'Weak',
      AssessmentResultType.fail => 'Fail',
    };
  }

  String get displayNameAr {
    return switch (this) {
      AssessmentResultType.excellent => 'ممتاز',
      AssessmentResultType.veryGood => 'جيد جداً',
      AssessmentResultType.good => 'جيد',
      AssessmentResultType.acceptable => 'مقبول',
      AssessmentResultType.weak => 'ضعيف',
      AssessmentResultType.fail => 'راسب',
    };
  }
}
