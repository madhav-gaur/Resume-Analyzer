import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resume_analyzer/models/analysis_model.dart';
import 'package:resume_analyzer/providers/analysis_provider.dart';
import 'package:resume_analyzer/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Analysis extends ConsumerStatefulWidget {
  final String analysisId;
  const Analysis({super.key, required this.analysisId});

  @override
  ConsumerState<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends ConsumerState<Analysis> {
  bool isLoading = false;
  Widget loadingState() {
    return Container();
  }

  Widget _overallScore({required int score}) {
    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(),
        ),
        child: Column(
          children: [
            const Text(
              'Overall Score',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),

            const SizedBox(height: 12),

            Text(
              '$score',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 52,
                fontWeight: FontWeight.w800,
              ),
            ),

            const Text(
              '/100',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),

            const SizedBox(height: 18),
            Stack(children: [

              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: score.clamp(0, 100) / 100,
                minHeight: 8,
                backgroundColor: AppColors.lightGrey,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreBadge({required int score}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$score/100',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _categoryCard({
    required String title,
    required int score,
    required String feedback,
    required List<String> suggestions,
  }) {
    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                Skeleton.ignore(child: _scoreBadge(score: score)),
              ],
            ),

            SizedBox(height: 14),

            Skeletonizer(
              enabled: feedback.isEmpty,
              child: feedback.isEmpty
                  ? Text("This is a sample text added for skeletonizer")
                  : Text(
                      feedback,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
            ),
            SizedBox(height: 18),

            Text(
              'Suggestions',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 10),

            ...suggestions.map(
              (suggestion) => Padding(
                padding: EdgeInsets.only(bottom: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      margin: EdgeInsets.only(top: 7, right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Skeletonizer(
                        enabled: suggestion.isEmpty,
                        child: suggestion.isEmpty
                            ? Text(
                                "This is a sample text added for skeletonizer",
                              )
                            : Text(
                                suggestion,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget analysisResult({required AnalysisModel analysis}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _overallScore(score: analysis.overallScore),

          const SizedBox(height: 28),

          const Text(
            'Resume Feedback',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          _categoryCard(
            title: 'Formatting',
            feedback: analysis.formatting.feedback,
            score: analysis.formatting.score,
            suggestions: analysis.formatting.suggestions,
          ),

          const SizedBox(height: 14),

          _categoryCard(
            title: 'Content & Impact',
            feedback: analysis.contentImpact.feedback,
            score: analysis.contentImpact.score,
            suggestions: analysis.contentImpact.suggestions,
          ),

          if (analysis.keywordMatch != null) ...[
            const SizedBox(height: 14),

            _categoryCard(
              title: 'Keyword Match',
              feedback: analysis.keywordMatch!.feedback,
              score: analysis.keywordMatch!.score,
              suggestions: analysis.keywordMatch!.suggestions,
            ),
          ],

          const SizedBox(height: 14),

          _categoryCard(
            title: 'Grammar & Clarity',
            feedback: analysis.grammarClarity.feedback,
            score: analysis.grammarClarity.score,
            suggestions: analysis.grammarClarity.suggestions,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final analysisId = widget.analysisId;
    final analysisAsync = ref.watch(analysisProvider(analysisId));
    return analysisAsync.when(
      data: (data) {
        final analysis = data;

        if (analysis == null) {
          return const Center(child: Text('Analysis not found'));
        }
        if (analysis.status == AnalysisStatus.failed) {
          return const Center(child: Text('Analysis failed'));
        }
        setState(() {
          isLoading = analysis.status == AnalysisStatus.processing;
        });
        return analysisResult(analysis: analysis);
      },
      error: (e, s) => Text(e.toString()),
      loading: () {
        setState(() {
          isLoading = true;
        });
        return CircularProgressIndicator();
      },
    );
  }
}
