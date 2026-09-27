import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/analysis_model.dart';

class AnalysisRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<AnalysisModel?> watchAnalysis({
    required String uid,
    required String analysisId,
  }) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('analysis')
        .doc(analysisId)
        .snapshots()
        .map((doc) {
          if (!doc.exists || doc.data() == null) {
            return null;
          }
          return AnalysisModel.fromMap(doc.id, doc.data()!);
        });
  }

  Stream<List<AnalysisModel>> getHistory({required String uid}) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('analysis')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return AnalysisModel.fromMap(doc.id, doc.data());
          }).toList();
        });
  }
}
