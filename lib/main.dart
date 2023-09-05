import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hecticai/api/chat_api.dart';
import 'package:hecticai/chat_page.dart';
import 'package:hecticai/dependency_injection/register_factory.dart';
import 'package:hecticai/firebase_options.dart';
import 'package:hecticai/screens/index_screen.dart';
import 'package:hecticai/screens/login_screen.dart';
import 'package:hecticai/styles/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  RegisterFactory().setup();
  runApp(ChatApp(chatApi: ChatApi()));
}

class ChatApp extends StatelessWidget {
  const ChatApp({required this.chatApi, super.key});

  final ChatApi chatApi;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppStyle.primary3,
        ),
        fontFamily: 'PPNeueMachina', //  primaryColor: AppStyle.primary2,
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? ChatPage(chatApi: chatApi)
          : RegisterScreen(chatApi: chatApi),
    );
  }
}


//  child: Padding(
        // padding: const EdgeInsets.all(12),
        // child: Row(
        //   children: [
        //     isUserMessage
        //         ? const Icon(
        //             Icons.person_4,
        //             color: AppStyle.white,
        //           )
        //         : const Icon(
        //             Icons.blur_on_sharp,
        //             color: AppStyle.primary2,
        //           ),
        //     // Text(
        //     //   isUserMessage ? 'You' : 'AI',
        //     //   style: TextStyle(
        //     //       fontFamily: 'PPNeueMachina-PlainRegular',
        //     //       fontSize: 18,
        //     //       color: isUserMessage ? AppStyle.white : AppStyle.primary2),
        //     // ),
        //     const SizedBox(width: 8),
        //     Text(
        //       content,
        //       style: TextStyle(
        //           fontFamily: 'PPNeueMachina-PlainRegular',
        //           fontSize: 18,
        //           color: isUserMessage ? AppStyle.white : AppStyle.primary2),
        //     ),
        //   ],
        // ),
    