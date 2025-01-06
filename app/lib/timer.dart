///
/// @brief     Page to do the workout with a timer
///
/// @author    CAZIN Némo & Adrien Paliferro
/// @date      2024 - 2025
/// 
/// Politecnico Di Milano
/// 
library DIMA;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';

const int setIndex = 8;
const int repetitionsIndex = 9;
const int restTimeIndex = 10;

class TimerPage extends StatefulWidget {
  
  const TimerPage({
    super.key, 
    required this.workoutName
  });
  
  final String workoutName;

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  List<dynamic> exercises = [];
  int currentExerciseIndex = 0;
  int currentSet = 0;
  int timerSeconds = 0;
  String timerLabel = "";
  Timer? timer;
  bool isWorkoutRunning = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    loadWorkoutData();
  }

  /**
   * @brief Load workout
   */
  Future<void> loadWorkoutData() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/program.json'); 

    if (await file.exists()) { 
      String contents = await file.readAsString(); 
      List<dynamic> data = json.decode(contents);
      if (contents.isNotEmpty) {
        final workout = data.firstWhere(
          (workout) => workout['workoutName'] == widget.workoutName,
          orElse: () => null,
        );

        if (workout != null) {
          setState(() {
            exercises = workout['exercises'];
            initializeExercise();
          });
        }
      }
    }
  }

  /**
   * @brief Initialize the exercices data for the timer
   */
  void initializeExercise() {
    if (currentExerciseIndex < exercises.length) {
      currentSet = 1;
      timerSeconds = 0;
      timerLabel = "Ready to start: ${exercises[currentExerciseIndex][1]}";
    } else {
      timer?.cancel();
      setState(() {
        timerLabel = "Workout Complete";
        timerSeconds = 0;
      });
    }
  }

  /**
   * @brief Set the timer
   */
  void startSetTimer() {
    if (currentExerciseIndex < exercises.length) {
      final exercise = exercises[currentExerciseIndex];
      final repetitions = exercise[repetitionsIndex];
      final restTime = exercise[restTimeIndex];

      if (!isPaused) {
        setState(() {
          timerSeconds = repetitions * 3;
          timerLabel = "Performing: ${exercise[1]}";
        });
      }

      isPaused = false;

      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timerSeconds > 1) {
          setState(() {
            timerSeconds--;
          });
        } else {
          timer.cancel();
          startRestTimer(restTime);
        }
      });
    }
  }

  /**
   * @brief Start the rest timer
   */
  void startRestTimer(int restTime) {
    if (!isPaused) {
      setState(() {
        timerSeconds = timerSeconds > 0 ? timerSeconds : restTime;
        timerLabel = "Resting";
      });
    }

    isPaused = false;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerSeconds > 1) {
        setState(() {
          timerSeconds--;
        });
      } else {
        timer.cancel();
        nextSetOrExercise();
      }
    });
  }

  /**
   * @brief GO to next exercice
   */
  void nextSetOrExercise() {
    if (currentExerciseIndex < exercises.length) {
      final exercise = exercises[currentExerciseIndex];
      final totalSets = exercise[setIndex];

      if (currentSet < totalSets) {
        setState(() {
          currentSet++;
        });
        startSetTimer();
      } else {
        setState(() {
          currentExerciseIndex++;
        });
        initializeExercise();
        if (isWorkoutRunning) startSetTimer();
      }
    } else {
      initializeExercise();
    }
  }

  /**
   * @brief Know where we are in the workout (Rest or execute exersice)
   */
  void toggleWorkout() {
    if (isWorkoutRunning) {
      timer?.cancel();
      isPaused = true;
    } else {
      if (currentExerciseIndex < exercises.length) {
        if (timerLabel == "Resting") {
          startRestTimer(timerSeconds);
        } else {
          startSetTimer();
        }
      }
    }
    setState(() {
      isWorkoutRunning = !isWorkoutRunning;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
          onPressed: () => Navigator.pop(context)
        ),
      ),
      backgroundColor: const Color(0xFF1c1e22),
      body: exercises.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Timer display
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          timerLabel,
                          style: TextStyle(
                            fontSize: fontSize * 1.5, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white  
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        // Sets left
                        Text(
                          'Time Remaining: $timerSeconds seconds',
                          style: TextStyle(
                            fontSize: fontSize * 1.2,
                            color: Colors.white    
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          exercises.isNotEmpty && currentExerciseIndex < exercises.length
                              ? 'Left: ${exercises[currentExerciseIndex][8] - currentSet + 1}/${exercises[currentExerciseIndex][8]}'
                              : '',
                          style: TextStyle(
                            fontSize: fontSize * 1.2,
                            color: Colors.white    
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                // Button at the bottom
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    children: [
                      if (currentExerciseIndex < exercises.length)
                        ElevatedButton(
                          onPressed: toggleWorkout,
                          child: Text(
                            isWorkoutRunning ? 'Stop Workout' : 'Start Workout',
                            style: TextStyle(fontSize: fontSize * 1.2), 
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: const Color(0xFF242b35),
                            alignment: Alignment.center,
                          ),
                        ),
                      if (currentExerciseIndex >= exercises.length)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MenuPage(),
                              ),
                            );
                          },
                          child: Text(
                            'End Workout',
                            style: TextStyle(fontSize: fontSize * 1.2), 
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: const Color(0xFF242b35),
                            alignment: Alignment.center,
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
