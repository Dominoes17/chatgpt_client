import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hecticai/styles/styles.dart';

class MessageComposer extends StatelessWidget {
  MessageComposer({
    required this.onSubmitted,
    required this.awaitingResponse,
    super.key,
  });

  final TextEditingController _messageController = TextEditingController();

  final void Function(String) onSubmitted;
  final bool awaitingResponse;

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: AppStyle.white,
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    maxLines: 15,
                    minLines: 1,
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Write your message here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                !awaitingResponse
                    ? Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: AppStyle.primary2,
                          child: IconButton(
                            onPressed: () {
                              _messageController.text.isNotEmpty
                                  ? onSubmitted(_messageController.text)
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            "Hectic!! You forgot to enter a message"),
                                      ),
                                    );
                            },
                            icon: Icon(
                              Icons.send,
                              color: AppStyle.white,
                              size: screenH * 0.023,
                            ),
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SpinKitThreeBounce(
                          size: 25,
                          color: AppStyle.primary2,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
