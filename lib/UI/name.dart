import 'package:flutter/material.dart';


class MyStepperScreen extends StatefulWidget {
  const MyStepperScreen({super.key});

  @override
  State<MyStepperScreen> createState() => _MyStepperScreenState();
}

class _MyStepperScreenState extends State<MyStepperScreen> {
  int currentStep = 0;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,

      ),
      body: Stepper(
        type: StepperType.horizontal, // Set to horizontal
        currentStep: currentStep,
        onStepContinue: () {
          setState(() {
            if (currentStep < 1) {
              currentStep += 1;
            } else {
              // Handle "Let's Go" button click
              String enteredName = nameController.text;
              print("Let's Go button clicked with name: $enteredName");
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (currentStep > 0) {
              currentStep -= 1;
            }
          });
        },
        steps: [
          Step(
            title: Text('Step 1'),
            content: Column(
              children: <Widget>[
                Text('Enter your name:'),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
              ],
            ),
            isActive: currentStep == 0,
          ),
          Step(
            title: Text('Step 2'),
            content: Column(
              children: <Widget>[
                Text('Review and confirm:'),
                Text('Name: ${nameController.text}'),
              ],
            ),
            isActive: currentStep == 1,
          ),
        ],
      ),
    );
  }
}
