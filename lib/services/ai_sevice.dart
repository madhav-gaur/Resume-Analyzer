import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:resume_analyzer/models/analysis_model.dart';

class AiService {
  static const _model = 'gemini-3.5-flash-lite';
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  Future<AnalysisModel> analyzeResume({
    required String resume,
    String? jobDescription,
  }) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is missing');
    }

    final isJobDesc =
        jobDescription != null && jobDescription.trim().isNotEmpty;

    final prompt =
        '''
You are a professional resume analyzer.
Analyze the following resume${isJobDesc ? ' against the target job description' : ''}.

RESUME:
$resume

${isJobDesc ? '''
TARGET JOB DESCRIPTION:
$jobDescription
''' : ''}

Evaluate the resume on:
1. Formatting
2. Content and Impact
3. Grammar and Clarity
${isJobDesc ? '4. Keyword Match' : ''}

Give each category:
- score from 0 to 100
- concise feedback
- specific actionable suggestions

Also provide an overall score from 0 to 100.

Return ONLY valid JSON with this structure:
{
  "overallScore": 0,
  "formatting": { "score": 0, "feedback": "", "suggestions": [] },
  "contentImpact": { "score": 0, "feedback": "", "suggestions": [] },
  ${isJobDesc ? '"keywordMatch": { "score": 0, "feedback": "", "suggestions": [] },' : ''}
  "grammarClarity": { "score": 0, "feedback": "", "suggestions": [] }
}
''';

    final uri = Uri.parse('$_baseUrl/$_model:generateContent?key=$apiKey');

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {'responseMimeType': 'application/json'},
      }),
    );


    if (res.statusCode != 200) {
      throw Exception('Gemini error ${res.statusCode}: ${res.body}');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final text =
        body['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;

    if (text == null || text.isEmpty) {
      throw Exception('Empty Gemini response: ${res.body}');
    }

    log('Gemini text: $text');

    final output = jsonDecode(text) as Map<String, dynamic>;
    return AnalysisModel.fromGeminiJson(
      output,
      resume: resume,
      jobDescription: jobDescription,
    );
  }
}
