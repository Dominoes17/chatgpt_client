import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hecticai/api/chat_api.dart';
import 'package:hecticai/dependency_injection/register_factory.dart';
import 'package:hecticai/logic/bloc.dart';
import 'package:hecticai/logic/states.dart';
import 'package:hecticai/models/chat_message.dart';
import 'package:hecticai/styles/styles.dart';
import 'package:hecticai/widgets/button.dart';
import 'package:hecticai/widgets/message_bubble.dart';
import 'package:hecticai/widgets/message_composer.dart';
import 'package:hecticai/widgets/message_textfield.dart';
import 'package:hecticai/widgets/model_selector.dart';
import 'package:dart_openai/dart_openai.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.chatApi,
    super.key,
    this.selectedChatId,
  });

  final ChatApi chatApi;
  final String? selectedChatId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final CollectionReference _chatMessagesRef;
  final ProductBloc _bloc = sl.get<ProductBloc>();
  String model = "gpt-3.5-turbo-16k-0613";
  String? chat = "sampleChat";

  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  // CollectionReference<Map<String, dynamic>> _getChatMessagesRef(
  //     String currentUser, String chat) {
  //   return FirebaseFirestore.instance
  //       .collection('users') // Replace 'currentUser' with 'users'
  //       .doc(currentUser)
  //       .collection('chats')
  //       .doc(chat) // Use .doc(chat) to access the specific chat
  //       .collection(
  //           'messages'); // Add .collection('messages') to access messages
  // }

  @override
  void initState() {
    super.initState();

    // _chatMessagesRef = _getChatMessagesRef(currentUser, chat!);

    // _retrieveChatHistory();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  List<ChatMessage> _messages = [
    ChatMessage('Hello, how can I help?', false),
  ];
  var _awaitingResponse = false;

  Future<void> _retrieveChatHistory() async {
    try {
      final chatSnapshot = await _chatMessagesRef.orderBy('timestamp').get();
      final chatDocs = chatSnapshot.docs;
      setState(() {
        _messages = chatDocs
            .map((doc) => ChatMessage(
                  doc['content'],
                  doc['isUserMessage'],
                ))
            .toList();
      });
    } catch (err) {
      // Handle any errors that occur while fetching chat history
      print('Error fetching chat history: $err');
    }
  }

  final ScrollController _scrollController = ScrollController();
  String selectedModel = 'GPT-3';
  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    final isPhone = screenH > screenW;
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 58, 64, 1),
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          !isPhone
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: screenW * 0.1,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 36, 36, 36),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          MyButton(
                              onTap: () {
                                setState(() {
                                  _messages.clear();
                                  _messages.add(
                                    ChatMessage(
                                        'Hello, how can I help?', false),
                                  );
                                });
                              },
                              height: screenH * 0.03,
                              width: screenW * 0.2,
                              color: AppStyle.black,
                              text: "+ New Chat"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyButton(
                                  height: screenH * 0.03,
                                  width: screenW * 0.035,
                                  color: AppStyle.black,
                                  text: "GPT-3.5",
                                  onTap: () {}),
                              MyButton(
                                  height: screenH * 0.03,
                                  width: screenW * 0.035,
                                  color: AppStyle.black,
                                  text: "GPT-4",
                                  onTap: () {}),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Spacer(),
                          MyButton(
                              onTap: () {},
                              height: screenH * 0.03,
                              width: screenW * 0.4,
                              color: AppStyle.black,
                              text: "Logout"),
                        ],
                      ),
                      //  const SaveFolders(
                      //   title: "Saved Folders",
                      //   children: [Text("data")],
                    ),
                  ),
                )
              : Container(),
          // isPhone
          //     ? Align(
          //         alignment: Alignment.topLeft,
          //         child: ElevatedButton(
          //             onPressed: () {}, child: const Icon(Icons.menu)))
          //     : Container(),
          SizedBox(
            height: double.infinity,
            width: !isPhone ? screenW * 0.89 : screenW,
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  //   shrinkWrap: true,
                  itemCount: _messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index < _messages.length) {
                      final msg = _messages[index];
                      return MessageBubble(
                        content: msg.content,
                        isUserMessage: msg.isUserMessage,
                      );
                    } else {
                      return SizedBox(height: screenH * 0.11);
                    }
                  },
                ),

                BlocBuilder(
                  bloc: _bloc,
                  builder: (context, state) {
                    if (state is ChangeChatSuccessState) {
                      chat = state.chat;
                      // _chatMessagesRef =
                      //     _getChatMessagesRef(currentUser, chat!);
                      // _retrieveChatHistory(); // Update chat history
                    }
                    if (state is ChangeModelSuccessState) {
                      model = state.model;
                      log("What is the model: ${state.model}");
                    }
                    return Container();
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: isPhone
                        ? const EdgeInsets.only(left: 8.0)
                        : const EdgeInsets.all(0),
                    child: Container(
                      width: !isPhone ? screenW * 0.5 : screenW * 0.9,
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        reverse: true,
                        child: MessageTextField(
                            onSubmitted: _onSubmitted,
                            awaitingResponse: _awaitingResponse),
                        // MessageComposer(
                        //   onSubmitted: _onSubmitted,
                        //   awaitingResponse: _awaitingResponse,
                        // ),
                      ),
                    ),
                  ),
                ),
                !isPhone
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Tooltip(
                            message: "Scroll to bottom",
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: AppStyle.primary2,
                              child: IconButton(
                                  onPressed: () {
                                    scrollBottom();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_downward_rounded,
                                    color: AppStyle.white,
                                  )),
                            ),
                          ),
                        ),
                      )
                    : Container()
                // const Align(
                //     alignment: Alignment.topCenter, child: ModelSelector()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void scrollToListBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void scrollBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onSubmitted(String message) async {
    setState(() {
      _messages.add(ChatMessage(message, true));
      _awaitingResponse = true;
    });
    try {
      final response = await widget.chatApi.completeChat(_messages, model);
      setState(() {
        _messages.add(ChatMessage(response, false));
        _awaitingResponse = false;
        scrollBottom();
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
      setState(() {
        _awaitingResponse = false;
      });
    }
  }

//   //SAVES TO FIREBASE
//   Future<void> _onSubmitted(String message) async {
//     setState(() {
//       _messages.add(ChatMessage(message, true));
//       _awaitingResponse = true;
//     });

//     try {
//       // Save user message to Firestore
//       final userMessage = {
//         'content': message,
//         'isUserMessage': true,
//         'timestamp': FieldValue.serverTimestamp(),
//       };
//       await _chatMessagesRef.add(userMessage);

//       // Continue with chatApi logic
//       final response = await widget.chatApi.completeChat(_messages, model);

//       scrollBottom();

//       // Save AI message to Firestore
//       final aiMessage = {
//         'content': response,
//         'isUserMessage': false,
//         'timestamp': FieldValue.serverTimestamp(),
//       };
//       await _chatMessagesRef.add(aiMessage);

//       setState(() {
//         _messages.add(ChatMessage(response, false));
//         _awaitingResponse = false;
//       });
//     } catch (err) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Network error occurred. Please try again. $err'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       setState(() {
//         _awaitingResponse = false;
//       });
//     }
//   }
}
