import 'package:flutter/material.dart';
import 'package:resume_analyzer/theme/app_colors.dart';
import 'package:resume_analyzer/theme/app_fonts.dart';
import 'package:resume_analyzer/widgets/home/home_input_card.dart';

class IdleHomeView extends StatelessWidget {
  final TextEditingController resumeController;
  final TextEditingController descriptionController;
  final bool isJobDescOpen;
  final bool isSubmitDisabled;
  final VoidCallback onSubmit;
  final VoidCallback onAddJobDescription;
  final VoidCallback onRemoveJobDescription;
  final ValueChanged<String>? onResumeChanged;

  const IdleHomeView({
    super.key,
    required this.resumeController,
    required this.descriptionController,
    required this.isJobDescOpen,
    required this.isSubmitDisabled,
    required this.onSubmit,
    required this.onAddJobDescription,
    required this.onRemoveJobDescription,
    this.onResumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Resume Analyzer',

                          style: TextStyle(
                            fontSize: 28.0,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Paste your resume and get actionable feedback',
                          textAlign: TextAlign.center,
                          style: AppFonts.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 28, bottom: 16),
                      child: HomeInputCard(
                        resumeController: resumeController,
                        descriptionController: descriptionController,
                        isJobDescOpen: isJobDescOpen,
                        isSubmitDisabled: isSubmitDisabled,
                        onSubmit: onSubmit,
                        onAddJobDescription: onAddJobDescription,
                        onRemoveJobDescription: onRemoveJobDescription,
                        onResumeChanged: onResumeChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
