import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peduli_kucing/features/ai/data/services/ai_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String? modelName;
  final double? durationSeconds;

  ChatMessage({
    required this.text, 
    required this.isUser,
    this.modelName,
    this.durationSeconds,
  });
}

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    required this.messages,
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final aiServiceProvider = Provider<AiService>((ref) {
  return AiService();
});

class AiChatNotifier extends StateNotifier<ChatState> {
  final AiService _aiService;

  AiChatNotifier(this._aiService) : super(ChatState(messages: []));

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message immediately
    final userMsg = ChatMessage(text: text, isUser: true);
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      error: null,
    );

    try {
      final history = state.messages
          .where((m) => m != userMsg)
          .map((m) => {
                'text': m.text,
                'isUser': m.isUser.toString(),
              })
          .toList();

      final startTime = DateTime.now();
      final response = await _aiService.getChatResponse(history, text);
      final endTime = DateTime.now();
      
      final duration = endTime.difference(startTime).inMilliseconds / 1000.0;
      
      final aiMsg = ChatMessage(
        text: response.text, 
        isUser: false,
        modelName: response.modelName,
        durationSeconds: duration,
      );
      
      state = state.copyWith(
        messages: [...state.messages, aiMsg],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final aiChatProvider = StateNotifierProvider<AiChatNotifier, ChatState>((ref) {
  final service = ref.watch(aiServiceProvider);
  return AiChatNotifier(service);
});
