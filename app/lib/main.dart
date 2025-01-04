///
/// @brief     Page for the principal menu of the app
///
/// @author    CAZIN Némo & Adrien Paliferro
/// @date      2024 - 2025
/// 
/// Politecnico Di Milano
/// 
library DIMA;

import 'dart:convert'; 
import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:path_provider/path_provider.dart';

import 'create_workout.dart';
import 'schedule.dart';
import 'recap_workout.dart';

const int exerciseDurationIndex = 11;

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  MenuPageState createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  static String workoutName = 'Undefined';
  static String startTime = '';
  static String endTime = '';

  @override
  void initState() {
    super.initState();
    createFilesIfNotExist();
    loadWorkoutData();
  }

  /**
   * @brief Create 2 JSON files if not existing at the start of the app
   */
  Future<void> createFilesIfNotExist() async {
    final currentDirectory  = await getApplicationDocumentsDirectory();
    String schedulePath = '${currentDirectory.path}/schedule.json';
    String programPath = '${currentDirectory.path}/program.json';

    // Verify if schedule.json exist
    File scheduleFile = File(schedulePath);
    if (!await scheduleFile.exists()) {
      Map<String, String> defaultSchedule = {
        "Monday": "Undefined",
        "Tuesday": "Undefined",
        "Wednesday": "Undefined",
        "Thursday": "Undefined",
        "Friday": "Undefined",
        "Saturday": "Undefined",
        "Sunday": "Undefined"
      };
      await scheduleFile.create(recursive: true); 
      await scheduleFile.writeAsString(jsonEncode(defaultSchedule)); 
    }

    // Verify if program.json exist
    File programFile = File(programPath);
    if (!await programFile.exists()) {
      List<dynamic> defaultProgram = [];
      await programFile.create(recursive: true); 
      await programFile.writeAsString(jsonEncode(defaultProgram)); 
    }
  }

  /**
   * @brief Get the information of the current workout for the day
   *        If no workout associated with the current date, declare undefined
   */
  Future<void> loadWorkoutData() async {
    final currentDirectory  = await getApplicationDocumentsDirectory();
    var scheduleData = await loadJson('${currentDirectory.path}/schedule.json');
    var programData = await loadJson('${currentDirectory.path}/program.json');

    DateTime now = DateTime.now();
    String dayName = DateFormat('EEEE').format(now);

    // Check if scheduleData is empty or if the current day is not in scheduleData
    setState(() {
      if (scheduleData.isEmpty || !scheduleData.containsKey(dayName)) {
        workoutName = 'Undefined';
        startTime = ''; 
        endTime = '';    
      } else {
        // Retrieve the current day's programme
        workoutName = scheduleData[dayName] ?? 'Undefined';
        int totalDurationInSeconds = calculateTotalDuration(workoutName, programData);
        DateTime endDateTime = now.add(Duration(seconds: totalDurationInSeconds));
        startTime = DateFormat('HH:mm').format(now);
        endTime = DateFormat('HH:mm').format(endDateTime);
      }
    });
  }

  /**
   * @brief Load a JSON file
   */
  Future<dynamic> loadJson(String path) async {
  try {
    File file = File(path);
    final content = await file.readAsString();
    if (content.isEmpty) {
      throw FormatException('JSON File is empty');
    }
    return json.decode(content); 
  } 
  catch (e) {
    print('Error loading JSON file: $e');
    return {}; 
  }
}

  /**
   * @brief Saving a JSON file
   */
  Future<void> saveJson(String path, Map<String, dynamic> data) async {
    final file = File(path);
    await file.writeAsString(jsonEncode(data));
  }

  /**
   * @brief // Calculate the total duration of a workout based on its name
   */
  int calculateTotalDuration(String workoutName, List<dynamic> programData) {
    int totalDuration = 0;
    for (var program in programData) {
      if (program['workoutName'] == workoutName) {
        for (var exercise in program['exercises']) {
          totalDuration += (exercise[exerciseDurationIndex] as int);
        }
      }
    }
    return (totalDuration ~/ 4);
  }

  /**
   * @brief Modify the programme for a given day
   *        Since when loading the JSON file is not updated because of the cache,
   *        we need to updated by hand the file 
   */
  Future<void> updateSchedule(String day, String newWorkout) async {
    final currendDirectory  = await getApplicationDocumentsDirectory();
    var scheduleData = await loadJson('${currendDirectory}/schedule.json');
    scheduleData[day] = newWorkout;
    await saveJson('${currendDirectory}/schedule.json', scheduleData);
    await loadWorkoutData();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.07; 
    double fontSize = screenHeight * 0.025;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add), 
          color: Colors.blue.shade100, 
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateWorkoutPage(
                  exerciseData: null,  
                  series: 0,        
                  repetitions: 0,  
                  restTime: 0,       
                ),
              ),
            );
          },
        ),
        title: const Text("Menu Page"),
        centerTitle: true, 
        backgroundColor: const Color(0xFF1c1e22),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            color: Colors.blue.shade100,
            onPressed: () {
              // Navigate to badgesPage
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1c1e22), 
      body: Column(
        children: [
          // Main content in ListView
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              children: [
                // Circle Avatar with date
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to recapPage
                    },
                    child: CircleAvatar(
                      radius: screenWidth * 0.2, 
                      backgroundColor: Colors.blue.shade100, 
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEEE').format(DateTime.now()), 
                            style: TextStyle(
                              fontSize: fontSize * 1.2,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2e4b5a),
                            ),
                          ),
                          Text(
                            DateFormat('d').format(DateTime.now()), 
                            style: TextStyle(
                              fontSize: fontSize * 1.6,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2e4b5a),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Workout information
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    children: [
                      Text(
                        workoutName,
                        style: TextStyle(
                          fontSize: fontSize * 1.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE1E0E0),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "Start time: $startTime",
                        style: TextStyle(
                          fontSize: fontSize,
                          color: const Color(0xFFE1E0E0),
                        ),
                      ),
                      Text(
                        "End time: $endTime",
                        style: TextStyle(
                          fontSize: fontSize,
                          color: const Color(0xFFE1E0E0), 
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom buttons
          Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF242b35),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutSchedulePage(),
                        ),
                      ).then((_) => loadWorkoutData());
                    },
                    child: Text(
                      "Modify Schedule", 
                      style: TextStyle(
                        fontSize: fontSize
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF242b35),
                    ),
                    onPressed: () {
                      if (workoutName == 'Undefined') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFF242b35),
                              title: Text(
                                "Warning !",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSize
                                ),
                              ),
                              content: Text(
                                "No workout selected for today ! Please select one.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSize
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: fontSize * 0.9,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecapWorkout(
                              startWorkout: true, 
                              workoutName: workoutName
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Start Workout", 
                      style: TextStyle(
                        fontSize: fontSize
                      ),
                      textAlign: TextAlign.center,
                    ),
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
