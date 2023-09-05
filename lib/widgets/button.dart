import 'package:flutter/material.dart';
import 'package:hecticai/styles/styles.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
      required this.height,
      required this.width,
      required this.color,
      required this.text,
      required this.onTap});
  final double height;
  final double width;
  final Color color;
  final String text;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: height,
          width: width,
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: color,
            child: Center(
                child: Text(
              text,
              style: const TextStyle(color: AppStyle.white),
            )),
          ),
        ),
      ),
    );
  }
}
