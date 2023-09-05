// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hecticai/api/chat_api.dart';
import 'package:hecticai/chat_page.dart';
import 'package:hecticai/styles/styles.dart';

class User {
  String name;
  String email;

  User({required this.name, required this.email});
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to handle user registration
  Future<User?> registerUser(String email, String password, String name) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's unique ID from the userCredential
      String uid = userCredential.user!.uid;

      // Create a new document in the "users" collection with the user's information
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
      });

      // Create a new collection for the user's chats
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc('sampleChat')
          .set({
        'message': 'Welcome to your chat!',
      });

      // Return the User object
      return User(name: name, email: email);
    } catch (e) {
      // Handle any errors that occur during registration
      print('Error during registration: $e');
      return null;
    }
  }

  // Function to handle user login
  Future<User?> loginUser(String email, String password) async {
    try {
      // Sign in the user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's unique ID from the userCredential
      String uid = userCredential.user!.uid;

      // Fetch the user's information from Firestore
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // Get the name and email from the user's Firestore document
      String name = userSnapshot['name'];
      String userEmail = userSnapshot['email'];

      // Return the User object
      return User(name: name, email: userEmail);
    } catch (e) {
      // Handle any errors that occur during login
      print('Error during login: $e');
      return null;
    }
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.chatApi});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
  final ChatApi chatApi;
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  void _handleRegister() async {
    setState(() {
      _loading = true;
    });

    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      // Handle empty fields error
      setState(() {
        _loading = false;
      });
      return;
    }

    User? user = await _authService.registerUser(email, password, name);
    setState(() {
      _loading = false;
    });

    if (user != null) {
      // Registration successful, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful: ${user.name}'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            chatApi: widget.chatApi,
          ),
        ),
      );
    } else {
      // Registration failed, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleLogin() async {
    setState(() {
      _loading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Handle empty fields error
      setState(() {
        _loading = false;
      });
      return;
    }

    User? user = await _authService.loginUser(email, password);
    setState(() {
      _loading = false;
    });

    if (user != null) {
      // Login successful, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful: ${user.name}'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            chatApi: widget.chatApi,
          ),
        ),
      );
    } else {
      // Login failed, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool islogin = false;
  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    final screenSize = MediaQuery.of(context).size;
    final isPhone = screenSize.height > screenSize.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppStyle.black,
              Colors.red,
              AppStyle.primary2,
              AppStyle.white
            ], // Replace these with your desired gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenH * 0.1,
              ),
              Text(
                "Hectic-AI",
                textScaleFactor: isPhone ? 2 : 6,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppStyle.white),
              ),
              SizedBox(
                height: screenH * 0.1,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: isPhone ? screenW * 0.9 : screenW * 0.2,
                  child: Material(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            islogin
                                ? TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                        labelText: 'Name'),
                                  )
                                : Container(),
                            TextField(
                              controller: _emailController,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                            ),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _loading
                  ? SpinKitThreeBounce(
                      color: AppStyle.primary1,
                      size: screenH * 0.04,
                    )
                  : SizedBox(
                      width: isPhone ? screenW * 0.9 : screenW * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.black)),
                            onPressed: () {
                              // Perform form validation here
                              if (_formKey.currentState!.validate()) {
                                // Validation successful, call the appropriate function
                                if (!islogin) {
                                  _handleLogin();
                                } else {
                                  _handleRegister();
                                }
                              }
                            },
                            child: Text(!islogin ? 'Login' : 'Register'),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  islogin = !islogin;
                                });
                              },
                              child: Text(
                                islogin ? "Login" : "Register",
                                style: TextStyle(color: AppStyle.white),
                              )),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
