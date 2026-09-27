import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resume_analyzer/models/analysis_model.dart';

class AnalysisService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<String?> initializeAnalysis({
    required String resume,
    String? jobDesc,
  }) async {
    if (user == null) return null;

    final doc = await _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('analysis')
        .add({
          "resume": resume,
          "jobDescription": jobDesc ?? "",
          "status": AnalysisStatus.processing.name,
          'createdAt': DateTime.now(),
        });

    return doc.id;
  }

  Future<void> saveAnalysis({
    required String analysisId,
    required AnalysisModel analysis,
  }) async {
    final uid = user?.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('analysis')
        .doc(analysisId)
        .update({
          'status': 'completed',
          'overallScore': analysis.overallScore,
          'formatting': analysis.formatting.toMap(),
          'contentImpact': analysis.contentImpact.toMap(),
          'keywordMatch': analysis.keywordMatch?.toMap(),
          'grammarClarity': analysis.grammarClarity.toMap(),
        });
  }
}
