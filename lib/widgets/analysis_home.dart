import 'package:flutter/material.dart';
import 'package:resume_analyzer/screens/analysis.dart';
import 'package:resume_analyzer/widgets/home/collapsed_input_header.dart';

class AnalysisHome extends StatelessWidget {
  final String? analysisId;
  final TextEditingController? resumeController;
  final TextEditingController? descriptionController;
  final bool isJobDescOpen;
  final bool isSubmitDisabled;
  final VoidCallback? onSubmit;
  final VoidCallback? onAddJobDescription;
  final VoidCallback? onRemoveJobDescription;

  const AnalysisHome({
    super.key,
    required this.analysisId,
    this.resumeController,
    this.descriptionController,
    this.isJobDescOpen = false,
    this.isSubmitDisabled = false,
    this.onSubmit,
    this.onAddJobDescription,
    this.onRemoveJobDescription,
  });

  @override
  Widget build(BuildContext context) {
    if (analysisId == null || analysisId!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final hasControllers = resumeController != null && descriptionController != null;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          if (hasControllers)
            SliverToBoxAdapter(
              child: CollapsedInputHeader(
                resumeController: resumeController!,
                descriptionController: descriptionController!,
                isJobDescOpen: isJobDescOpen,
                isSubmitDisabled: isSubmitDisabled,
                onSubmit: onSubmit ?? () {},
                onAddJobDescription: onAddJobDescription ?? () {},
                onRemoveJobDescription: onRemoveJobDescription ?? () {},
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Analysis(analysisId: analysisId!),
            ),
          ),
        ],
      ),
    );
  }
}
