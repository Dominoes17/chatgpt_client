import 'package:flutter/material.dart';
import 'package:hecticai/styles/styles.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppStyle.black,
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: screenH * 0.05,
              ),
              const Text(
                "Hectic - \n        AI*",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppStyle.white),
                textScaleFactor: 10,
              ),
              Container(
                height: screenH * 0.4,
                width:
                    double.infinity, // Takes up the whole width of the screen
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0), // Padding on each side
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, // Gradient start from top-left
                    end: Alignment.bottomRight, // Gradient ends at bottom-right
                    colors: [
                      AppStyle.black,
                      Colors.red,
                      AppStyle.primary2,
                      AppStyle.white
                    ], // Colors in the gradient (you can add more colors here)
                  ),
                ),
                child: const Center(
                  child: Text(
                    'The alternative to Chat GPT!',
                    style: TextStyle(color: AppStyle.black, fontSize: 24.0),
                  ),
                ),
              ),
              SizedBox(
                height: screenH * 0.1,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppStyle.white),
                  minimumSize: MaterialStateProperty.all(
                      Size(screenW * 0.15, screenH * 0.08)),
                ),
                onPressed: () {},
                child: const Text(
                  "Join The  Waitlist",
                  style: TextStyle(color: AppStyle.black),
                ),
              ),
              Container(
                height: screenH * 0.5,
                child: Row(
                  children: [Material()],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
