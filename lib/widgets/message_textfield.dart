import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hecticai/styles/styles.dart';

class MessageTextField extends StatelessWidget {
  MessageTextField(
      {super.key, required this.onSubmitted, required this.awaitingResponse});
  final void Function(String) onSubmitted;
  final bool awaitingResponse;

  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: TextFormField(
                  onTap: () {
                    onSubmitted(_messageController.text);
                  },
                  maxLines: 15,
                  minLines: 1,
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Write your message here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            !awaitingResponse
                ? Padding(
                    padding: const EdgeInsets.all(2),
                    child: GestureDetector(
                      onTap: () {
                        onSubmitted(_messageController.text);
                      },
                      child: Material(
                        color: AppStyle.primary2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.send, color: AppStyle.white),
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
    );
  }
}
