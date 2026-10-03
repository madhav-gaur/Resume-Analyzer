import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resume_analyzer/models/analysis_model.dart';
import 'package:resume_analyzer/providers/analysis_provider.dart';
import 'package:resume_analyzer/router/routes.dart';
import 'package:resume_analyzer/services/ai_sevice.dart';
import 'package:resume_analyzer/services/analysis_service.dart';
import 'package:resume_analyzer/widgets/analysis_home.dart';
import 'package:resume_analyzer/widgets/app_drawer.dart';
import 'package:resume_analyzer/widgets/home/idle_home_view.dart';

class Home extends ConsumerStatefulWidget {
  final String? analysisId;

  const Home({super.key, this.analysisId});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

enum _HomePhase { idle, process }

class _HomeState extends ConsumerState<Home> {
  final TextEditingController _resumeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool isLoading = false;
  bool isJobDesc = false;
  String? _analysisId;
  _HomePhase _phase = _HomePhase.idle;
  bool _restoreInputFromAnalysis = false;

  bool get isDisabled => _resumeController.text.trim().isEmpty;

  @override
  void initState() {
    super.initState();
    if (widget.analysisId != null) {
      _analysisId = widget.analysisId;
      _phase = _HomePhase.process;
      _restoreInputFromAnalysis = true;
    }
  }

  @override
  void dispose() {
    _resumeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addJobDescription() {
    setState(() {
      isJobDesc = true;
    });
  }

  void _removeJobDescription() {
    setState(() {
      isJobDesc = false;
      _descriptionController.clear();
    });
  }

  Future<void> _analyzeResume() async {
    if (isDisabled) return;

    final resume = _resumeController.text.trim();
    final jobDescription = _descriptionController.text.trim();

    try {
      final id = await AnalysisService().initializeAnalysis(
        resume: resume,
        jobDesc: jobDescription,
      );

      if (id == null) {
        if (!mounted) return;
        return;
      }

      setState(() {
        _analysisId = id;
        _phase = _HomePhase.process;
      });

      final AnalysisModel analysis = await AiService().analyzeResume(
        resume: resume,
        jobDescription: jobDescription,
      );

      await AnalysisService().saveAnalysis(analysisId: id, analysis: analysis);
    } catch (e) {
      log(e.toString());
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final analysisId = _analysisId;
    if (_restoreInputFromAnalysis && analysisId != null) {
      ref.listen(analysisProvider(analysisId), (previous, next) {
        next.whenData((analysis) {
          if (!mounted || analysis == null || !_restoreInputFromAnalysis) {
            return;
          }

          _restoreInputFromAnalysis = false;
          setState(() {
            _resumeController.text = analysis.resume;
            _descriptionController.text = analysis.jobDescription ?? '';
            isJobDesc = _descriptionController.text.trim().isNotEmpty;
          });
        });
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: AppDrawer(),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          if (_phase != _HomePhase.idle)
            IconButton(
              onPressed: () => context.go(AppRoutes.home),
              icon: const Icon(Icons.chat_bubble_outline),
            ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0, 0.35],
            colors: [Color.fromARGB(45, 33, 65, 243), Colors.black],
          ),
        ),
        child: _phase == _HomePhase.idle
            ? IdleHomeView(
                resumeController: _resumeController,
                descriptionController: _descriptionController,
                isJobDescOpen: isJobDesc,
                isSubmitDisabled: isDisabled,
                onSubmit: _analyzeResume,
                onAddJobDescription: _addJobDescription,
                onRemoveJobDescription: _removeJobDescription,
                onResumeChanged: (_) => setState(() {}),
              )
            : AnalysisHome(
                analysisId: _analysisId,
                resumeController: _resumeController,
                descriptionController: _descriptionController,
                isJobDescOpen: isJobDesc,
                isSubmitDisabled: isDisabled,
                onSubmit: _analyzeResume,
                onAddJobDescription: _addJobDescription,
                onRemoveJobDescription: _removeJobDescription,
              ),
      ),
    );
  }
}
