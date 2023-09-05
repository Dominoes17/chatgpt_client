import 'package:flutter/material.dart';
import 'package:hecticai/dependency_injection/register_factory.dart';
import 'package:hecticai/logic/bloc.dart';
import 'package:hecticai/logic/events.dart';

class ModelSelector extends StatelessWidget {
  const ModelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final ProductBloc bloc = sl.get<ProductBloc>();
    return SizedBox(
      width: screenW * 0.2,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                bloc.add(ChangeModel(model: "gpt-3.5-turbo"));
              },
              child: const Text("GPT-3.5"),
            ),
            const SizedBox(
              width: 40,
            ),
            ElevatedButton(
              onPressed: () {
                bloc.add(ChangeModel(model: "gpt-4"));
                print("MODEL GPT-4");
              },
              child: const Text("GPT-4"),
            ),
          ],
        ),
      ),
    );
  }
}
