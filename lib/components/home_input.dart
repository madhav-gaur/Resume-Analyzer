import 'package:flutter/material.dart';
import 'package:resume_analyzer/theme/app_colors.dart';

InputDecoration inputDecoration({
  required String hint,
  required BorderRadius borderRadius,
  EdgeInsets contentPadding = const EdgeInsets.fromLTRB(30, 20, 60, 20),
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      fontSize: 17,
    ),
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: contentPadding,
    border: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide.none,
    ),
  );
}
