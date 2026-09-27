import 'package:flutter/material.dart';
import 'package:resume_analyzer/theme/app_colors.dart';
import 'package:resume_analyzer/theme/app_fonts.dart';
import 'package:resume_analyzer/widgets/home/home_input_card.dart';

class CollapsedInputHeader extends StatefulWidget {
  final TextEditingController resumeController;
  final TextEditingController descriptionController;
  final bool isJobDescOpen;
  final bool isSubmitDisabled;
  final VoidCallback onSubmit;
  final VoidCallback onAddJobDescription;
  final VoidCallback onRemoveJobDescription;
  final ValueChanged<bool>? onExpansionChanged;

  const CollapsedInputHeader({
    super.key,
    required this.resumeController,
    required this.descriptionController,
    required this.isJobDescOpen,
    required this.isSubmitDisabled,
    required this.onSubmit,
    required this.onAddJobDescription,
    required this.onRemoveJobDescription,
    this.onExpansionChanged,
  });

  @override
  State<CollapsedInputHeader> createState() => _CollapsedInputHeaderState();
}

class _CollapsedInputHeaderState extends State<CollapsedInputHeader> {
  late bool _expanded;

  @override
  Widget build(BuildContext context) {
    final resumeText = widget.resumeController.text.trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: false,
            onExpansionChanged: (open) {
              setState(() {
                _expanded = open;
              });
              widget.onExpansionChanged?.call(open);
            },
            tilePadding: const EdgeInsets.symmetric(horizontal: 20),
            childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            title: Text(
              'Your input',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: !_expanded
                ? Text(
                    resumeText.isEmpty ? 'Resume' : resumeText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  )
                : null,
            children: [
              HomeInputCard(
                resumeController: widget.resumeController,
                descriptionController: widget.descriptionController,
                isJobDescOpen: widget.isJobDescOpen,
                isSubmitDisabled: widget.isSubmitDisabled,
                onSubmit: widget.onSubmit,
                onAddJobDescription: widget.onAddJobDescription,
                onRemoveJobDescription: widget.onRemoveJobDescription,
                resumeHeight: null,
                jobDescHeight: null,
                resumeMinLines: 4,
                resumeMaxLines: 15,
                jobDescMinLines: 2,
                jobDescMaxLines: 8,
                showOuterFill: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
