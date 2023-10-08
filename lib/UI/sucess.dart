import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SucessScreen extends StatefulWidget {
  const SucessScreen({super.key});

  @override
  State<SucessScreen> createState() => _SucessScreenState();
}

class _SucessScreenState extends State<SucessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Lottie animation
            Lottie.asset(
              'assets/lottiee/tick.json', // Replace with your Lottie animation file
              height: 160, // Adjust the size of the animation
            ),

            const SizedBox(height: 35.0), // Add spacing between Lottie and text

            // Row with two text widgets
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Successfully',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 18.0), // Add spacing between text widgets
                Text(
                  'Your Call has been scheduled',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(
                height: 100.0), // Add spacing between text and button

            ElevatedButton(
              onPressed: () {
                 GoRouter.of(context).push('/dataentry');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber, // Button color
                minimumSize: Size(200, 50), // Button size
              ),
              child: const Text(
                'Okay',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
