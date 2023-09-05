import 'package:flutter/material.dart';
import 'package:hecticai/styles/styles.dart';
import 'package:markdown_widget/markdown_widget.dart';
// import 'package:markdown/markdown.dart' as md;

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.content,
    required this.isUserMessage,
    Key? key,
  }) : super(key: key);

  final String content;
  final bool isUserMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 48, 36, 54),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Icon(
            isUserMessage ? Icons.person : Icons.blur_on_sharp,
            color: !isUserMessage ? AppStyle.white : AppStyle.primary2,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MarkdownWidget(
                selectable: true,
                markdownGeneratorConfig: MarkdownGeneratorConfig(

                    // textGenerator: (node, config, visitor) {
                    //   return CodeBlockNode(content, PreConfig.darkConfig);
                    // },
                    ),
                data: content,
                shrinkWrap: true,
                config: MarkdownConfig(
                  configs: [
                    const CodeConfig(
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                    !isUserMessage
                        ? const PConfig(
                            textStyle: TextStyle(color: AppStyle.white))
                        : const PConfig(
                            textStyle: TextStyle(
                            color: AppStyle.primary2,
                            fontWeight: FontWeight.w500,
                          )),
                    const H1Config(style: TextStyle(color: AppStyle.primary2))
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
