import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'recap_workout.dart';
import 'main.dart';

import 'manage_workout.dart';

class WorkoutSchedulePage extends StatefulWidget {
  @override
  _WorkoutSchedulePageState createState() => _WorkoutSchedulePageState();
}

class _WorkoutSchedulePageState extends State<WorkoutSchedulePage> {
  List<String> daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  Map<String, String> schedule = {};
  List<String> workoutPrograms = [];

  @override
  void initState() {
    super.initState();
    _loadWorkoutPrograms();
    _loadSchedule();
  }

  /**
   * @brief Load the JSON file and save in a variables all the workout saved
   */
  Future<void> _loadWorkoutPrograms() async {
    try {
      final file = File('data/program.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> programs = jsonDecode(content);
        setState(() {
          workoutPrograms = programs.map((p) => p['workoutName'] as String).toList();
          workoutPrograms.insert(0, "Undefined");
        });
      }
    } catch (e) {
      print("Error loading workout programs: $e");
    }
  }

  /**
   * @brief Load all the workout associated with the days
   */
  Future<void> _loadSchedule() async {
    try {
      final file = File('data/schedule.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        setState(() {
          schedule = Map<String, String>.from(jsonDecode(content));
        });
      }
    } catch (e) {
      print("Error loading schedule: $e");
    }
  }

  /**
   * @brief Save the new schedule
   */
  Future<void> _saveSchedule() async {
    try {
      final file = File('data/schedule.json');
      // Ensure all days are saved, even if not defined
      Map<String, String> completeSchedule = {
        for (var day in daysOfWeek) day: schedule[day] ?? "Undefined"
      };
      
      await file.writeAsString(jsonEncode(completeSchedule));
    } catch (e) {
      print("Error saving schedule: $e");
    }
  }

  /**
   * @brief Rest all days with the "Undefined" workout
   *        Used by the "reset all" button
   */
  void _resetSchedule() {
    setState(() {
      schedule = {for (var day in daysOfWeek) day: "Undefined"};
    });
    _saveSchedule();
  }

  /**
   * @brief Dialog to show all the workouts when selecting one
   */
  void _selectWorkoutProgram(String day) async {
    if (workoutPrograms.isEmpty) return;

    String? selectedProgram = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF242b35),
          title: Text(
            "Select Workout Program for $day",
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: workoutPrograms.map((program) {
                return ListTile(
                  title: Text(
                    program,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(context, program),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    if (selectedProgram != null) {
      setState(() {
        schedule[day] = selectedProgram;
      });
      _saveSchedule();
      if (selectedProgram == "Undefined") {
        return;
      } else if (schedule.length == daysOfWeek.length) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecapWorkout(startWorkout: false, workoutName: selectedProgram),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                builder: (context) => MenuPage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue.shade100),
            onPressed: _resetSchedule,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1c1e22),
      body: Column(
        children: [
          Expanded(
            // List of each days
            child: ListView.builder(
              itemCount: daysOfWeek.length,
              itemBuilder: (context, index) {
                String day = daysOfWeek[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF242b35),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(
                        day,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        schedule[day] ?? "Undefined",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => _selectWorkoutProgram(day),
                    ),
                  ),
                );
              },
            ),
          ),
          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF242b35),
                alignment: Alignment.center, 
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageWorkout(),
                  ),
                );
              },
              child: const Text("Manage Workouts"),
            ),
          ),
        ],
      ),
    );
  }
}

