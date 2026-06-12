import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {
  static final String _groqApiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  static final String _geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  static const String systemPrompt = '''
Kamu adalah Dr. Mochi AI, seekor kucing pintar yang menjabat sebagai Dokter Hewan Spesialis Kucing di aplikasi Peduli Kucing.
Kamu harus:
1. Menjawab HANYA pertanyaan seputar kesehatan, nutrisi, penyakit, dan perawatan medis kucing secara komprehensif dan akurat.
2. Jika ditanya hal di luar kucing atau medis hewan, tolak dengan sopan dengan gaya bahasa kucing lucu (misalnya: "Meow! Maaf paw-rents, Mochi cuma dokter spesialis kucing nih. Kalau tanya soal itu Mochi kurang paham purr~").
3. Selalu ingatkan bahwa jawabanmu adalah panduan awal dan jika kondisi kucing gawat darurat, sarankan untuk segera dibawa ke klinik hewan terdekat.
4. Gunakan gaya bahasa yang ramah, sedikit playful (tambahkan kata "Meow" atau "Purr" sesekali tapi jangan berlebihan), namun tetap profesional dalam memberikan saran medis.
5. Gunakan bahasa Indonesia yang baik, santai, dan mudah dipahami.
''';

  Future<({String text, String modelName})> getChatResponse(List<Map<String, String>> chatHistory, String newMessage) async {
    try {
      // 1. Try Groq First (Fastest)
      final text = await _getGroqResponse(chatHistory, newMessage);
      return (text: text, modelName: 'Llama 3.3 (Groq)');
    } catch (e) {
      debugPrint('Groq failed: $e. Falling back to Gemini...');
      // 2. Fallback to Gemini
      final text = await _getGeminiResponse(chatHistory, newMessage);
      return (text: text, modelName: 'Gemini 1.5 Pro');
    }
  }

  Future<String> _getGroqResponse(List<Map<String, String>> chatHistory, String newMessage) async {
    const url = 'https://api.groq.com/openai/v1/chat/completions';
    
    final messages = [
      {'role': 'system', 'content': systemPrompt},
    ];

    for (var msg in chatHistory) {
      messages.add({
        'role': msg['isUser'] == 'true' ? 'user' : 'assistant',
        'content': msg['text'] ?? '',
      });
    }

    messages.add({'role': 'user', 'content': newMessage});

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_groqApiKey',
      },
      body: jsonEncode({
        'model': 'llama-3.3-70b-versatile',
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 1024,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Groq API Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<String> _getGeminiResponse(List<Map<String, String>> chatHistory, String newMessage) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: _geminiApiKey,
      systemInstruction: Content.system(systemPrompt),
    );

    final history = chatHistory.map((msg) {
      final role = msg['isUser'] == 'true' ? 'user' : 'model';
      return Content(role, [TextPart(msg['text'] ?? '')]);
    }).toList();

    final chat = model.startChat(history: history);
    final response = await chat.sendMessage(Content.text(newMessage));
    
    if (response.text != null) {
      return response.text!;
    } else {
      throw Exception('Gemini returned null response');
    }
  }
}
