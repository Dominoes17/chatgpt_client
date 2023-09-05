import 'package:dart_openai/dart_openai.dart';
import 'package:hecticai/models/chat_message.dart';

class ChatApi {
  static const _model = 'gpt-3.5-turbo-16k-0613';

  ChatApi() {
    OpenAI.apiKey = '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';
  }

  Future<String> completeChat(
    List<ChatMessage> messages,
    String model,
  ) async {
    final chatCompletion = await OpenAI.instance.chat.create(
      model: _model,
      messages: messages
          .map((e) => OpenAIChatCompletionChoiceMessageModel(
                role: e.isUserMessage
                    ? OpenAIChatMessageRole.user
                    : OpenAIChatMessageRole.assistant,
                content: e.content,
              ))
          .toList(),
    );

    print("Token count TOTAL: ${chatCompletion.usage.totalTokens}");
    return chatCompletion.choices.first.message.content;
  }
}
