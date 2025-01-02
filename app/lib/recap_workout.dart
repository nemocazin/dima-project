import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'main.dart';
import 'timer.dart';

const int seriesIndex = 8;
const int repetitionsIndex = 9;
const int restTimeIndex = 10;

class RecapWorkout extends StatelessWidget {
  final bool startWorkout;
  final String workoutName;

  const RecapWorkout({Key? key, required this.startWorkout, required this.workoutName}) : super(key: key);

  /**
   * @brief Function for retrieving exercise data
   */
  Future<List<List<dynamic>>> _fetchWorkout(String workoutName) async {
    try {
      final file = File('data/program.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> programs = jsonDecode(content);

        for (var program in programs) {
          if (program['workoutName'] == workoutName) {
            return List<List<dynamic>>.from(program['exercises']);
          }
        }
      }
    } catch (e) {
      print("Error fetching workout: $e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.07;
    double fontSize = screenHeight * 0.025;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1c1e22),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.blue.shade100,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFF1c1e22),
      body: FutureBuilder<List<List<dynamic>>>(
        future: _fetchWorkout(workoutName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading workout data.',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            final exercises = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Text(
                    '$workoutName Recap',
                    style: TextStyle(
                      fontSize: fontSize * 1.5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Exercises List
                Expanded(
                  child: ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: padding),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF242b35),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(
                              exercise[1] ?? 'Unknown Exercise',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                            ),
                            subtitle: Text(
                              'Series: ${exercise[seriesIndex]}, Repetitions: ${exercise[repetitionsIndex]}, Rest: ${exercise[restTimeIndex]} sec',
                              style: TextStyle(color: Colors.white70, fontSize: fontSize * 0.8),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Bottom Button
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF242b35),
                        alignment: Alignment.center,
                      ),
                      onPressed: () {
                        if (startWorkout) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimerPage(workoutName: workoutName),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuPage(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        startWorkout ? 'Go to Timer' : 'Return to Home Page',
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
