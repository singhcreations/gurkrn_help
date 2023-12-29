import 'package:flutter/material.dart';
import 'package:gurbani_app/widgets/constraints.dart';

class Shabadui extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shabad',style: TextStyle(color: whiteColor,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite,color: whiteColor,),
            onPressed: () {
              // Handle heart icon tap
              // Add your functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.build,color: whiteColor,),
            onPressed: () {
              // Handle tool icon tap
              // Add your functionality here
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert,color: whiteColor,),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  child:  Text('Share as Text'),
                  // Add your functionality for Item 1
                ),
                const PopupMenuItem(
                  child: Text('Share as Image'),
                  // Add your functionality for Item 2
                ),
                // Add more PopupMenuItems as needed
              ];
            },
          ),
        ],
      ),
      drawer: Drawer(
        // Add your drawer content here
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Drawer Item 1'),
              onTap: () {
                // Add your functionality for Drawer Item 1
              },
            ),
            ListTile(
              title: const Text('Drawer Item 2'),
              onTap: () {
                // Add your functionality for Drawer Item 2
              },
            ),
            // Add more ListTiles for additional drawer items
          ],
        ),
      ),
      body: const Center(
        child: Text('Your main content goes here'),
      ),
    );
  }
}