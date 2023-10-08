import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class TimeSlotSelectionScreen extends StatefulWidget {
  const TimeSlotSelectionScreen({super.key});

  @override
  State<TimeSlotSelectionScreen> createState() =>
      _TimeSlotSelectionScreenState();
}

class _TimeSlotSelectionScreenState extends State<TimeSlotSelectionScreen> {
  final List<String> timeSlots = [
    '1:00 AM',
    '1:15 AM',
    '1:30 AM',
    '1:45 AM',
    '2:00 AM',
    '2:15 AM',
    '2:30 AM',
    '2:45 AM',
    '3:00 AM',
    '3:15 AM',
    '3:30 AM',
    '3:45 AM',
    '4:00 AM',
    '4:15 AM',
    '4:30 AM',
    '4:45 AM',
  ];

  List<bool> isSelectedList = List.generate(16, (index) => false);

  int selectedIndex = -1;

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
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: Lottie.asset('assets/lottiee/timeslotanim.json'),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select a Time Slot',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 32.0, left: 15, right: 15),
                  child: Container(
                    // color: Colors.black,
                    height: 255,

                    // width: 500,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 2 columns
                        crossAxisSpacing: 11.0,
                        mainAxisSpacing: 11.0,
                        childAspectRatio: 1 / .65,
                      ),
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        return TimeSlotTile(
                          timeSlot: timeSlots[index],
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
                        print(
                            'Selected time slot: ${timeSlots[selectedIndex]}');
                        GoRouter.of(context).replace('/sucess');
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
  final bool isSelected;
  final VoidCallback onTap;

  TimeSlotTile(
      {required this.timeSlot, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              timeSlot,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold, // Customize the text color
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
