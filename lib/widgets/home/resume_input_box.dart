import 'package:flutter/material.dart';
import 'package:resume_analyzer/components/home_input.dart';
import 'package:resume_analyzer/theme/app_colors.dart';

class ResumeInputBox extends StatelessWidget {
  final TextEditingController controller;
  final bool isJobDescOpen;
  final bool isSubmitDisabled;
  final VoidCallback onSubmit;
  final ValueChanged<String>? onChanged;
  final double? height;
  final int? minLines;
  final int? maxLines;
  final bool showOuterFill;

  const ResumeInputBox({
    super.key,
    required this.controller,
    required this.isJobDescOpen,
    required this.isSubmitDisabled,
    required this.onSubmit,
    this.onChanged,
    this.height = 300,
    this.minLines,
    this.maxLines,
    this.showOuterFill = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.vertical(
      top: const Radius.circular(32),
      bottom: Radius.circular(isJobDescOpen ? 0 : 32),
    );

    Widget textField = TextField(
      controller: controller,
      onChanged: onChanged,
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
        hint: 'Type or paste your resume here...',
        borderRadius: borderRadius,
        contentPadding: const EdgeInsets.fromLTRB(30, 25, 75, 25),
      ),
    );

    if (height != null) {
      textField = SizedBox(height: height, child: textField);
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
            right: 14,
            bottom: 14,
            child: IconButton(
              onPressed: isSubmitDisabled ? null : onSubmit,
              style: IconButton.styleFrom(
                backgroundColor: isSubmitDisabled
                    ? const Color.fromARGB(137, 99, 99, 99)
                    : AppColors.primary,
                disabledBackgroundColor: const Color(0x88636363),
                shape: const CircleBorder(),
                fixedSize: const Size(46, 46),
              ),
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
