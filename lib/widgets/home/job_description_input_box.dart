import 'package:flutter/material.dart';
import 'package:resume_analyzer/components/home_input.dart';
import 'package:resume_analyzer/theme/app_colors.dart';

class JobDescriptionInputBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onRemove;
  final double? height;
  final int? minLines;
  final int? maxLines;
  final bool showOuterFill;

  const JobDescriptionInputBox({
    super.key,
    required this.controller,
    required this.onRemove,
    this.height = 180,
    this.minLines,
    this.maxLines,
    this.showOuterFill = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = const BorderRadius.vertical(
      bottom: Radius.circular(32),
    );

    Widget textField = TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      scrollPhysics: const BouncingScrollPhysics(),
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: inputDecoration(
        hint: 'Target job description (optional)...',
        borderRadius: borderRadius,
        contentPadding: const EdgeInsets.fromLTRB(30, 25, 55, 25),
      ),
    );

    if (height != null) {
      textField = SizedBox(
        height: height,
        child: textField,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: showOuterFill ? AppColors.surface : Colors.transparent,
        borderRadius: borderRadius,
      ),
      child: Stack(
        children: [
          textField,
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: onRemove,
              icon: const Icon(
                Icons.close,
                size: 18,
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.textPrimary,
                foregroundColor: AppColors.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
