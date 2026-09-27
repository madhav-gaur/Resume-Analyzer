import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:go_router/go_router.dart';
import 'package:resume_analyzer/components/buttons.dart';
import 'package:resume_analyzer/models/analysis_model.dart';
import 'package:resume_analyzer/providers/analysis_provider.dart';
import 'package:resume_analyzer/router/routes.dart';
import 'package:resume_analyzer/theme/app_colors.dart';
import 'package:resume_analyzer/theme/app_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(analysisHistoryProvider);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      height: double.infinity,
      width: MediaQuery.widthOf(context) - 80,
      decoration: BoxDecoration(color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Text('Resume Analyzer', style: AppFonts.screenTitle),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Recents',
              style: AppFonts.screenTitle.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          SizedBox(height: 12),
          Expanded(
            child: historyAsync.when(
              data: (analyses) {
                if (analyses.isEmpty) {
                  return Center(
                    child: Text(
                      'No recent analyses',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: analyses.length,
                  itemBuilder: (context, index) {
                    final analysis = analyses[index];

                    return _historyItem(analysis: analysis, isLoading: false);
                  },
                );
              },

              loading: () {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _historyItem(isLoading: true);
                  },
                );
              },

              error: (e, s) {
                log('History error: $e');

                return Center(
                  child: Text(
                    'Some error occurred',
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: PrimaryButton(
                  width: 150,
                  label: 'New Analysis',
                  onPressed: () {
                    context.pop();
                    context.go(AppRoutes.home);
                  },
                ),
              ),

              PopupMenuButton<String>(
                position: PopupMenuPosition.over,
                icon: CircleAvatar(
                  radius: 18,

                  foregroundColor: AppColors.background,
                  backgroundColor: AppColors.textPrimary,
                  child: Icon(Icons.person_2_outlined),
                ),

                onSelected: (value) async {
                  if (value == 'logout') {
                    await FirebaseAuth.instance.signOut();

                    if (context.mounted) {
                      context.go(AppRoutes.signin);
                    }
                  }
                },

                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 10),
                        Text('Log Out'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _historyItem({AnalysisModel? analysis, required bool isLoading}) {
    return Skeletonizer(
      enabled: isLoading,
      child: Material(
        color: Colors.black,
        child: ListTile(
          tileColor: Colors.transparent,
          splashColor: AppColors.lightGrey,
          title: analysis != null
              ? Text(
                  analysis.jobDescription != null &&
                          analysis.jobDescription!.trim().isNotEmpty
                      ? 'Job Application Analysis'
                      : 'Resume Analysis',
                  style: TextStyle(color: Colors.white),
                )
              : Text("Loading Resume..."),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${analysis?.overallScore}/100',
                style: const TextStyle(color: Colors.white54),
              ),
              analysis != null && analysis.createdAt != null
                  ? Text(GetTimeAgo.parse(analysis.createdAt!))
                  : Text("Loading Time..."),
            ],
          ),

          trailing: const Icon(Icons.chevron_right, color: Colors.white54),

          onTap: () {
            if (analysis != null) {
              context.push('/analysis/${analysis.id}');
            }
          },
        ),
      ),
    );
  }
}
