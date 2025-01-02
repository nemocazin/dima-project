import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class ManageWorkout extends StatefulWidget {
  @override
  _ManageWorkoutState createState() => _ManageWorkoutState();
}

class _ManageWorkoutState extends State<ManageWorkout> {
  List<Map<String, dynamic>> workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  // Loading data from the JSON file
  Future<void> _loadWorkouts() async {
    final file = File('data/program.json');
    if (await file.exists()) {
      String contents = await file.readAsString();
      setState(() {
        workouts = List<Map<String, dynamic>>.from(json.decode(contents));
      });
    }
  }

  // Delete a workout and update the JSON file with the correct indentation
  Future<void> _deleteWorkout(int index) async {
    setState(() {
      workouts.removeAt(index);
    });

    final file = File('data/program.json');
    String jsonString = json.encode(workouts, toEncodable: (dynamic nonEncodable) => nonEncodable.toString());
  
    String formattedJson = const JsonEncoder.withIndent('  ').convert(json.decode(jsonString));

    await file.writeAsString(formattedJson);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFF1c1e22),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Colors.blue.shade100,
        onPressed: () => Navigator.pop(context)
      ),
    ),
    backgroundColor: const Color(0xFF1c1e22),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: workouts.isEmpty 
      ? Center( // If the list is empty, no workouts
          child: Text(
            'No more workouts program',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      : ListView.builder( // List of all the workouts
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0), 
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), 
              decoration: BoxDecoration(
                color: const Color(0xFF242b35),
                borderRadius: BorderRadius.circular(8), 
              ),
              child: Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    workout['workoutName'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  // Red cross for deleting workouts
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(), 
                    icon: Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () => _deleteWorkout(index),
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
