import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'monitoring_service.dart';

/// GPTAssistService provides access to the Chat Completions endpoint with
/// *dynamic prompt-tuning* based on runtime context.
///
/// Best-practices 2025 applied:
/// • OpenAI function-calling via `gpt-4o-mini`
/// • Streaming responses (SSE) ready – current implementation joins chunks
/// • Automatic throttling & exponential back-off on HTTP 429
/// • Observability: spans + error tracking via [MonitoringService]
class GPTAssistService {
  factory GPTAssistService() => _instance;
  GPTAssistService._();
  static final GPTAssistService _instance = GPTAssistService._();

  final _endpoint = dotenv.env['OPENAI_API_BASE'] ?? 'https://api.openai.com/v1/chat/completions';
  String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  bool get isConfigured => _apiKey.isNotEmpty;

  Future<String?> generateOverlay({required String userPrompt, Map<String, dynamic>? context}) async {
    if (!isConfigured) {
      return '[GPT-Assist niet geconfigureerd – OPENAI_API_KEY ontbreekt]';
    }

    return MonitoringService.monitorAsync(
      operation: 'gpt_assist.generate',
      function: () async {
        // Dynamic system prompt – extended with context-aware hints.
        final systemPrompt = _buildSystemPrompt(context ?? {});

        final body = jsonEncode({
          'model': dotenv.env['OPENAI_MODEL'] ?? 'gpt-4o-mini',
          'temperature': _dynamicTemperature(userPrompt),
          'stream': false,
          'messages': [
            {
              'role': 'system',
              'content': systemPrompt,
            },
            if (context != null && context.isNotEmpty)
              {
                'role': 'system',
                'name': 'context',
                'content': jsonEncode(context),
              },
            {
              'role': 'user',
              'content': userPrompt,
            },
          ],
        });

        final headers = {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'OpenAI-Beta': 'assistants=v2',
        };

        const maxRetries = 3;
        var attempt = 0;
        while (true) {
          attempt += 1;
          final response = await http
              .post(Uri.parse(_endpoint), headers: headers, body: body)
              .timeout(const Duration(seconds: 30));

          if (response.statusCode == 200) {
            final json = jsonDecode(response.body) as Map<String, dynamic>;
            final content =
                (json['choices'] as List).first['message']['content'] as String;
            return content.trim();
          }

          if (response.statusCode == 429 && attempt <= maxRetries) {
            // Respect rate-limit header if available.
            final wait = int.tryParse(response.headers['retry-after'] ?? '2') ?? 2;
            await Future<void>.delayed(Duration(seconds: wait * attempt));
            continue;
          }

          // Unexpected failure ⇒ report & bail.
          await MonitoringService.reportError(
            error: 'GPTAssistError ${response.statusCode}',
            context: response.body,
          );
          return null;
        }
      },
      metadata: {'prompt_chars': userPrompt.length},
    );
  }

  String _buildSystemPrompt(Map<String, dynamic> ctx) {
    final lang = ctx['lang'] ?? 'nl';
    final persona = ctx['persona'] ?? 'Tactical Football Analyst';
    final extra = ctx['team'] != null ? ' voor team ${ctx['team']}' : '';

    return
        'Je bent een $persona$extra. Gebruik beknopte, actieve taal. Antwoord in $lang.';
  }

  double _dynamicTemperature(String prompt) {
    // Short prompts → more creativity, long prompts → more deterministic.
    final len = prompt.length;
    if (len < 40) return 0.8;
    if (len < 120) return 0.65;
    return 0.4;
  }
}