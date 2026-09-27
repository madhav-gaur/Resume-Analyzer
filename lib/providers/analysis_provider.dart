import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resume_analyzer/models/analysis_model.dart';
import 'package:resume_analyzer/repository/analysis_repo.dart';

final analysisRepositoryProvider = Provider<AnalysisRepo>((ref) {
  return AnalysisRepo();
});

final analysisProvider = StreamProvider.family<AnalysisModel?, String>((
  ref,
  analysisId,
) {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final repository = ref.watch(analysisRepositoryProvider);

  return repository.watchAnalysis(uid: uid, analysisId: analysisId);
});

final analysisHistoryProvider = StreamProvider<List<AnalysisModel>>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User is not logged in');
  }

  final repo = ref.watch(analysisRepositoryProvider);
  return repo.getHistory(uid: user.uid);
});
