///
/// @brief     Page to delete saved workouts
///
/// @author    CAZIN Némo & Adrien Paliferro
/// @date      2024 - 2025
/// 
/// Politecnico Di Milano
/// 
library DIMA;

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'schedule.dart';

class ManageWorkout extends StatefulWidget {
  const ManageWorkout({super.key});

  @override
  ManageWorkoutState createState() => ManageWorkoutState();
}

class ManageWorkoutState extends State<ManageWorkout> {
  List<Map<String, dynamic>> workouts = [];

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS || Platform.isAndroid) {
      loadWorkouts();  
    }
  }

  /**
   * @brief Loading data from the JSON file
   */
  Future<void> loadWorkouts() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/program.json'); 

    if (await file.exists()) { 
      String contents = await file.readAsString(); 

      if (contents.isNotEmpty) {
        setState(() {
          workouts = List<Map<String, dynamic>>.from(json.decode(contents));
        });
      }
    }
  }

  /**
   * @brief Delete a workout and update the JSON file
   */
  Future<void> deleteWorkout(int index) async {
    setState(() {
      workouts.removeAt(index);
    });

    // Format content
    String jsonString = json.encode(workouts, toEncodable: (dynamic nonEncodable) => nonEncodable.toString());
    String formattedJson = const JsonEncoder.withIndent('  ').convert(json.decode(jsonString));

    // Save JSON
    try {
      final directory  = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/program.json');
      if (!await file.exists()) {
        await file.create();
      }
      await file.writeAsString(formattedJson);
    } 
    catch (e) {
      throw Exception('Error when saving the JSON file : $e');
    }
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutSchedulePage(),
              ),
            );
          }
        ),
      ),
      backgroundColor: const Color(0xFF1c1e22),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: workouts.isEmpty 
        ? Center( // If the list is empty, no workouts
            child: Text(
              'No more workouts program',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
          // List of all the workouts
        : ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0), 
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: padding, vertical: screenHeight * 0.015), 
                  decoration: BoxDecoration(
                    color: const Color(0xFF242b35),
                    borderRadius: BorderRadius.circular(8), 
                  ),
                  child: Row( 
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        workout['workoutName'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                      ),
                      // Red cross for deleting workouts
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(), 
                        icon: Icon(Icons.close, color: Colors.red, size: fontSize),
                        onPressed: () => deleteWorkout(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ),
    );
  }
}
