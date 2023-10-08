import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SelectlanguageScreen extends StatefulWidget {
  const SelectlanguageScreen({super.key});

  @override
  State<SelectlanguageScreen> createState() => _SelectlanguageScreenState();
}

class _SelectlanguageScreenState extends State<SelectlanguageScreen> {
  final List<String> language = [
    'English',
    'Punjabi',
    'Hindi',
    'Hinglish',
  ];
  final List<String> desclanguage = [
    'How are You?',
    'ਤੁਸੀਂ ਕਿਵੇਂ ਹੋ ?',
    'कैसे है आप ?',
    'Kaise hai aap?',
  ];

  List<bool> isSelectedList = List.generate(4, (index) => false);

  int selectedIndex = -1;
  int newindex = 0;

  void handleSelection(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.sizeOf(context);

    return SafeArea(
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 2, 6, 80),
            appBar: null,
            body: Column(
              children: [
                const SizedBox(
                  height: 120,
                ),
                const Align(
                    alignment: Alignment.centerLeft, // Align text to the left
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Choose' + '\n' 'Your Language',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 50.0, left: 20, right: 25),
                  child: Container(
                    // color: Colsors.black,
                    height: 280,
                    // width: 500,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 columns
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 1 / .76,
                      ),
                      itemCount: language.length,
                      itemBuilder: (context, index) {
                        return TimeSlotTile(
                          timeSlot: language[index],
                          newpyr: desclanguage[index],
                          isSelected: index == selectedIndex,
                          onTap: () {
                            handleSelection(index);
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedIndex != -1) {
                        print('Selected time slot: ${language[selectedIndex]}');
                        GoRouter.of(context).replace('/timeslot');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber, // Button color
                      minimumSize: Size(200, 50), // Button size
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}

class TimeSlotTile extends StatelessWidget {
  final String timeSlot;
  final String newpyr;
  final bool isSelected;
  final VoidCallback onTap;

  TimeSlotTile(
      {required this.timeSlot,
      required this.isSelected,
      required this.onTap,
      required this.newpyr});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
        child: Container(
          decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(8)),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Text(
                    newpyr,
                    style: const TextStyle(
                      color: Colors.black, // Customize the text color
                      fontSize: 21,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    timeSlot,
                    style: const TextStyle(
                        color: Colors.black, // Customize the text color
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
