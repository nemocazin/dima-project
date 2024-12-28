import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

import 'create_workout.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get actual date
    DateTime now = DateTime.now();
    String dayName = DateFormat('EEEE').format(now); // Day name
    String dayNumber = DateFormat('d').format(now);  // Day number

    return Scaffold(
      appBar: AppBar(
        // + Button
        leading: IconButton(
          icon: const Icon(Icons.add), 
          color: Colors.blue.shade100, 
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateWorkoutPage()),
            );
          },
        ),

        title: const Text("Menu Page"),
        centerTitle: true, 
        backgroundColor: const Color(0xFF1c1e22), 

        // Badges button   
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            color: Colors.blue.shade100,
            onPressed: () {
              // Naviguer vers badgesPage
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1c1e22), 

      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Naviguer vers recapPage
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 80, 
                backgroundColor: Colors.blue.shade100, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Actual day text
                    Text(
                      dayName, 
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2e4b5a), 
                      ),
                    ),
                    // Actual day number text
                    Text(
                      dayNumber, 
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2e4b5a), 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), 

          // Workout of the day text
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Workout Name",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE1E0E0), 
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Start time: 17:00",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE1E0E0),
                  ),
                ),
                Text(
                  "End time: 19:00",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE1E0E0), 
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Button for modifying the workout of the day
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF242b35), 
                      alignment: Alignment.center, 
                    ),
                    onPressed: () {
                      // Change workout
                    },
                    child: const Text("Modify Schedule"),
                  ),
                ),
                const SizedBox(width: 16), 
                // Start workout Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF242b35),
                      alignment: Alignment.center, 
                    ),
                    onPressed: () {
                      // Naviguer vers timerPage
                    },
                    child: const Text("Start Workout"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MenuPage(),
  ));
}
