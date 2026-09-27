import 'package:cloud_firestore/cloud_firestore.dart';

enum AnalysisStatus { processing, completed, failed }

class CategoryFeedback {
  final int score;
  final String feedback;
  final List<String> suggestions;

  CategoryFeedback({
    required this.score,
    required this.feedback,
    required this.suggestions,
  });

  factory CategoryFeedback.fromMap(Map<String, dynamic> map) {
    return CategoryFeedback(
      score: _toInt(map['score']),
      feedback: map['feedback']?.toString() ?? '',
      suggestions:
          map['suggestions'].map((item) => item.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {'score': score, 'feedback': feedback, 'suggestions': suggestions};
  }
}

class AnalysisModel {
  final String id;
  final String resume;
  final String? jobDescription;

  final int overallScore;
  final AnalysisStatus status;

  final CategoryFeedback formatting;
  final CategoryFeedback contentImpact;
  final CategoryFeedback? keywordMatch;
  final CategoryFeedback grammarClarity;

  final DateTime? createdAt;

  AnalysisModel({
    required this.id,
    required this.resume,
    this.jobDescription,
    required this.status,
    required this.overallScore,
    required this.formatting,
    required this.contentImpact,
    this.keywordMatch,
    required this.grammarClarity,
    this.createdAt,
  });

  factory AnalysisModel.fromGeminiJson(
    Map<String, dynamic> json, {
    required String resume,
    String? jobDescription,
  }) {
    return AnalysisModel(
      id: '',
      resume: resume,
      jobDescription: jobDescription,
      status: AnalysisStatus.completed,
      overallScore: _toInt(json['overallScore']),
      formatting: CategoryFeedback.fromMap(_asMap(json['formatting'])),
      contentImpact: CategoryFeedback.fromMap(_asMap(json['contentImpact'])),
      keywordMatch: json['keywordMatch'] == null
          ? null
          : CategoryFeedback.fromMap(_asMap(json['keywordMatch'])),
      grammarClarity: CategoryFeedback.fromMap(_asMap(json['grammarClarity'])),
      createdAt: DateTime.now(),
    );
  }

  factory AnalysisModel.fromMap(String id, Map<String, dynamic> map) {
    return AnalysisModel(
      id: id,
      resume: map['resume']?.toString() ?? '',
      jobDescription: map['jobDescription']?.toString(),
      status: _toAnalysisStatus(map['status']),
      overallScore: _toInt(map['overallScore']),
      formatting: CategoryFeedback.fromMap(_asMap(map['formatting'])),
      contentImpact: CategoryFeedback.fromMap(_asMap(map['contentImpact'])),
      keywordMatch: map['keywordMatch'] == null
          ? null
          : CategoryFeedback.fromMap(_asMap(map['keywordMatch'])),
      grammarClarity: CategoryFeedback.fromMap(_asMap(map['grammarClarity'])),
      createdAt: _toDateTime(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'resume': resume,
      'jobDescription': jobDescription,
      'status': status.name,
      'overallScore': overallScore,
      'formatting': formatting.toMap(),
      'contentImpact': contentImpact.toMap(),
      'keywordMatch': keywordMatch?.toMap(),
      'grammarClarity': grammarClarity.toMap(),
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }

  @override
  String toString() {
    return 'AnalysisModel('
        'id: $id, '
        'status: ${status.name}, '
        'overallScore: $overallScore, '
        'formatting: ${formatting.score}, '
        'contentImpact: ${contentImpact.score}, '
        'grammarClarity: ${grammarClarity.score}, '
        'keywordMatch: ${keywordMatch?.score}'
        ')';
  }
}

AnalysisStatus _toAnalysisStatus(dynamic value) {
  switch (value?.toString()) {
    case 'completed':
      return AnalysisStatus.completed;

    case 'failed':
      return AnalysisStatus.failed;

    case 'processing':
    default:
      return AnalysisStatus.processing;
  }
}

int _toInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  return <String, dynamic>{};
}

DateTime? _toDateTime(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }

  if (value is DateTime) {
    return value;
  }

  return null;
}
