import 'package:flutter/material.dart';
import 'package:hecticai/styles/styles.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.content,
    required this.isUserMessage,
    super.key,
  });

  final String content;
  final bool isUserMessage;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return Container(
      //  width: screenW,
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(42, 46, 49, 1),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            isUserMessage
                ? const Icon(
                    Icons.person_4,
                    color: AppStyle.white,
                  )
                : const Icon(
                    Icons.blur_on_sharp,
                    color: AppStyle.primary2,
                  ),
            // Text(
            //   isUserMessage ? 'You' : 'AI',
            //   style: TextStyle(
            //       fontFamily: 'PPNeueMachina-PlainRegular',
            //       fontSize: 18,
            //       color: isUserMessage ? AppStyle.white : AppStyle.primary2),
            // ),
            const SizedBox(width: 8),

            // Markdown(
            //   data: content,
            //   selectable: true,
            //   shrinkWrap: true,
            //   styleSheet: MarkdownStyleSheet(
            //     p: const TextStyle(color: AppStyle.primary2),
            //     h1: const TextStyle(color: AppStyle.primary2),
            //   ),
            // ),

            // Text(
            //   content,
            //   style: TextStyle(
            //       fontFamily: 'PPNeueMachina',
            //       fontSize: 18,
            //       color: isUserMessage ? AppStyle.white : AppStyle.primary2),
            // ),
          ],
        ),
      ),
    );
  }
}
