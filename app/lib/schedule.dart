///
/// @brief     Page to associate a workout to a day of the week
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
import 'recap_workout.dart';
import 'main.dart';

import 'manage_workout.dart';

class WorkoutSchedulePage extends StatefulWidget {
  const WorkoutSchedulePage({super.key});
  
  @override
  WorkoutSchedulePageState createState() => WorkoutSchedulePageState();
}

class WorkoutSchedulePageState extends State<WorkoutSchedulePage> {
  List<String> daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  Map<String, String> schedule = {};
  List<String> workoutPrograms = [];

  @override
  void initState() {
    super.initState();
    loadWorkoutPrograms().then((_) {
      loadSchedule().then((_) {
        validateSchedule();
      });
    });
  }

  /**
   * @brief Checks that each associated program still exists
   *        If not, replace with ‘Undefined’.
   */
  void validateSchedule() {
    bool hasChanges = false;
    
    schedule.forEach((day, workout) {
      if (workout != "Undefined" && !workoutPrograms.contains(workout)) {
        schedule[day] = "Undefined";
        hasChanges = true;
      }
    });

    if (hasChanges) {
      setState(() {});
      saveSchedule(); 
    }
  }

  /**
   * @brief Load the JSON file and save in a variables all the workout saved
   */
  Future<void> loadWorkoutPrograms() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/program.json'); 
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
  Future<void> loadSchedule() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/schedule.json'); 
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
  Future<void> saveSchedule() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/schedule.json'); 
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
  void resetSchedule() {
    setState(() {
      schedule = {for (var day in daysOfWeek) day: "Undefined"};
    });
    saveSchedule();
  }

  /**
   * @brief Dialog to show all the workouts when selecting one
   */
  void selectWorkoutProgram(String day) async {
    if (workoutPrograms.isEmpty) return;

    String? selectedProgram = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        double screenHeight = MediaQuery.of(context).size.height;
        double fontSize = screenHeight * 0.024; 
        return AlertDialog(
          backgroundColor: const Color(0xFF242b35),
          title: Text(
            "Select Workout Program for $day",
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: workoutPrograms.map((program) {
                return ListTile(
                  title: Text(
                    program,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize * 0.9
                    ),
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
      saveSchedule();
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
                builder: (context) => MenuPage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue.shade100),
            onPressed: resetSchedule,
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
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: padding),
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
                          fontSize: fontSize,
                        ),
                      ),
                      trailing: Text(
                        schedule[day] ?? "Undefined",
                        style: TextStyle(
                          fontSize: fontSize * 1.2,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => selectWorkoutProgram(day),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Bottom buttons
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageWorkout(),
                    ),
                  );
                },
                child: Text(
                  "Manage Workouts",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
