import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hecticai/dependency_injection/register_factory.dart';
import 'package:hecticai/logic/bloc.dart';
import 'package:hecticai/logic/events.dart';
import 'package:hecticai/styles/styles.dart';

class SaveFolders extends StatefulWidget {
  const SaveFolders({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;
  @override
  State<SaveFolders> createState() => _SaveFoldersState();
}

class _SaveFoldersState extends State<SaveFolders> {
  String? selectedChatId;

  bool isExpanded = false;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  final ProductBloc _bloc = sl.get<ProductBloc>();

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser)
          .collection('chats')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting, show the loading icon
          return const Center(
            child: SpinKitThreeBounce(
              color: AppStyle.white,
              size: 50.0,
            ),
          );
        } else if (snapshot.hasError) {
          // Handle any errors that occur while fetching data
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          // Data is available, show the ListView.builder
          return ListView.builder(
            itemCount: snapshot.data!.docs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Display the ElevatedButton for "+ New Chat"
                return ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppStyle.primary3)),
                  onPressed: () {
                    addChatDocument();
                  },
                  child: const Text(
                    '+ New Chat',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                );
              } else {
                // Regular list item
                var chatName = snapshot.data!.docs[index - 1].id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _bloc.add(
                        ChangeChat(chat: chatName),
                      );
                    });
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          height: screenH * 0.02,
                          width: double.infinity,
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 3, color: AppStyle.white))),
                            child: Text(
                              chatName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppStyle.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ListTile(
                      //   title: Text(
                      //     chatName,
                      //     style: const TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       color: AppStyle.white,
                      //     ),
                      //   ),
                      //   trailing: Icon(
                      //     isExpanded
                      //         ? Icons.keyboard_arrow_up
                      //         : Icons.keyboard_arrow_down,
                      //     color: AppStyle.white,
                      //   ),
                      //   onTap: () {
                      //     setState(() {
                      //       isExpanded = !isExpanded;
                      //     });
                      //   },
                      //   subtitle: isExpanded
                      //       ? Column(children: widget.children)
                      //       : null,
                      // ),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  Future<void> addChatDocument() async {
    try {
      // Reference to the chats collection document
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser)
          .collection('chats')
          .add({
        'message': 'Welcome',
      });

      // Add the new document to the chats collection

      print('Document added successfully to the chats collection.');
    } catch (e) {
      print('Error adding document to the chats collection: $e');
      // Handle any error if necessary
    }
  }
}
