import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SucessScreen extends StatefulWidget {
  const SucessScreen({super.key});

  @override
  State<SucessScreen> createState() => _SucessScreenState();
}

class _SucessScreenState extends State<SucessScreen> {
  String selectedOption = 'Search by Any';
  TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 320,
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: selectedOption,
                items: [
                  'Search by Any',
                  'First Letters from Start',
                  'First Letters from Anywhere'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (string) {},
                style: TextStyle(fontSize: 18.0, color: Colors.black),
                icon: Icon(Icons.arrow_drop_down, size: 30.0),
              ),
              
            ),

            SizedBox(height: 30),
            //
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextController,
                      decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle:
                              TextStyle(fontSize: 18.0, color: Colors.grey)),
                    ),
                  ),
                  SizedBox(width: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple, // Background color
                      shape: BoxShape.rectangle,
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                      onPressed: () {
                        // Perform search based on selected option and entered text
                        String searchOption = selectedOption;
                        String searchText = searchTextController.text;

                        // Implement your logic for searching here
                        print(
                            'Search Option: $searchOption, Search Text: $searchText');
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Lottie animation

            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/home');
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
