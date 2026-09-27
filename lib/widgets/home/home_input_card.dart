import 'package:flutter/material.dart';
import 'package:resume_analyzer/theme/app_colors.dart';
import 'package:resume_analyzer/theme/app_fonts.dart';
import 'package:resume_analyzer/widgets/home/job_description_input_box.dart';
import 'package:resume_analyzer/widgets/home/resume_input_box.dart';

class HomeInputCard extends StatelessWidget {
  final TextEditingController resumeController;
  final TextEditingController descriptionController;
  final bool isJobDescOpen;
  final bool isSubmitDisabled;
  final VoidCallback onSubmit;
  final VoidCallback onAddJobDescription;
  final VoidCallback onRemoveJobDescription;
  final ValueChanged<String>? onResumeChanged;
  final double? resumeHeight;
  final double? jobDescHeight;
  final int? resumeMinLines;
  final int? resumeMaxLines;
  final int? jobDescMinLines;
  final int? jobDescMaxLines;
  final bool showOuterFill;

  const HomeInputCard({
    super.key,
    required this.resumeController,
    required this.descriptionController,
    required this.isJobDescOpen,
    required this.isSubmitDisabled,
    required this.onSubmit,
    required this.onAddJobDescription,
    required this.onRemoveJobDescription,
    this.onResumeChanged,
    this.resumeHeight = 300,
    this.jobDescHeight = 180,
    this.resumeMinLines,
    this.resumeMaxLines,
    this.jobDescMinLines,
    this.jobDescMaxLines,
    this.showOuterFill = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ResumeInputBox(
          controller: resumeController,
          isJobDescOpen: isJobDescOpen,
          isSubmitDisabled: isSubmitDisabled,
          onSubmit: onSubmit,
          onChanged: onResumeChanged,
          height: resumeHeight,
          minLines: resumeMinLines,
          maxLines: resumeMaxLines,
          showOuterFill: showOuterFill,
        ),
        if (isJobDescOpen)
          JobDescriptionInputBox(
            controller: descriptionController,
            onRemove: onRemoveJobDescription,
            height: jobDescHeight,
            minLines: jobDescMinLines,
            maxLines: jobDescMaxLines,
            showOuterFill: showOuterFill,
          ),
        if (!isJobDescOpen)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onAddJobDescription,
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                'Add target job description',
                style: AppFonts.caption.copyWith(color: AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }
}
