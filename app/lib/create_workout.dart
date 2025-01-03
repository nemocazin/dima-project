import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'add_exercise.dart';
import 'main.dart';

const int exerciseName = 1;
const int averageTimeRepet = 3;
const int caloriesIndex = 6;
const int setIndex = 8;
const int repetitionsIndex = 9;
const int restTimeIndex = 10;

class CreateWorkoutPage extends StatefulWidget {
  final List<dynamic>? exerciseData; 
  final int? series;                 
  final int? repetitions;            
  final int? restTime;               

  const CreateWorkoutPage({
    Key? key,
    this.exerciseData,   
    this.series,         
    this.repetitions,    
    this.restTime,       
  }) : super(key: key);

  @override
  _CreateWorkoutPage createState() => _CreateWorkoutPage();
}

class _CreateWorkoutPage extends State<CreateWorkoutPage> {
  static List<List<dynamic>> selectedExercises = [];
  static int totalTimeSec = 0; 
  static int totalTimeMin = 0; 
  static int totalCalories = 0;

  @override
  void initState() {
    super.initState();
    if (widget.exerciseData != null) {
      setState(() {
        // Add the settings to the exercise before being transferred to the list of selected exercise
        widget.exerciseData?.add(widget.series);
        widget.exerciseData?.add(widget.repetitions);
        widget.exerciseData?.add(widget.restTime);
        totalTimeSec = (((averageTimeRepet * widget.repetitions!) * widget.series!) + widget.series! * widget.restTime!).toInt();
        widget.exerciseData?.add(totalTimeSec);
        // Adding exercise to the selected list and making calculations
        selectedExercises.add(widget.exerciseData!); 
        totalTimeMin = ((totalTimeSec) ~/ 60).toInt();
        totalCalories = (widget.repetitions! * (widget.exerciseData?[caloriesIndex] as int? ?? 0)) * widget.series! * averageTimeRepet ~/ 60;
      });
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
            _resetVariables();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuPage(),
              ),
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFF1c1e22),
      body: Column(
        children: [
          // Header with totals and config
          Container(
            padding: EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Time and calories column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total time: ${_CreateWorkoutPage.totalTimeMin} min',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE1E0E0),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total calories: ${_CreateWorkoutPage.totalCalories} kcal',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE1E0E0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          /**
           * IF EXERCISES IS EMPTY
           * We show an icon and text explaining we need to select an exercise
           */
          if (selectedExercises.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 80, 
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No exercises selected!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add an exercise to get started',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            )
          /**
           * IF EXERCISES IS NOT EMPTY
           * We show the list of selected exercises
           */
          else
            Expanded(
              child: ListView.builder(
                itemCount: selectedExercises.length,
                itemBuilder: (context, index) {
                  final exercise = selectedExercises[index];
                  return Card(
                    color: const Color(0xFF242b35),
                    margin: EdgeInsets.symmetric(horizontal: padding, vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        exercise[exerciseName],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                      ),
                      // Red cross
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedExercises.removeAt(index);
                            _recalculateTotals();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

          // Bottom buttons fixed at the bottom
          Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF242b35),
                      alignment: Alignment.center,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddExercisePage()),
                      );
                    },
                    child: Text(
                      'Add Exercise',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF242b35),
                      alignment: Alignment.center,
                    ),
                    onPressed: () => _showSaveDialog(),
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: fontSize),
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

  /**
   * @brief Show the dialog when saving the workout program
   */
  void _showSaveDialog() async {
    TextEditingController workoutNameController = TextEditingController();

    /**
     * IF EXERCISES IS EMPTY
     * We show an AlertDialog to say to choose an exercise
     */
    if (selectedExercises.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF242b35),
          title: const Text(
            'Please select an exercise!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      );
    } else {
      /**
       * IF EXERCISES IS NOT EMPTY
       * We show an AlertDialog to save the program
       */
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF242b35),
          title: const Text(
            'Save Workout',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: workoutNameController, 
            decoration: InputDecoration(
              labelText: 'Workout Name',
              labelStyle: TextStyle(
                color: Colors.blue,
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String workoutName = workoutNameController.text.trim();
                if (workoutName.isNotEmpty) {
                  _saveProgram(workoutName, selectedExercises);
                  Navigator.pop(context);
                  _resetVariables();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuPage(),
                    ),
                  );
                } 
                /**
                 * Text Input empty so error message
                 */
                else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF242b35),
                      title: const Text(
                        'Error',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Please enter a workout name.',
                        style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      );
    }
  }

  /**
   * @brief Save the data in the JSON file
   * @warning As there may already be data in the file, we need to save it to add our own data
   */
  Future<void> _saveProgram(String workoutName, List<List<dynamic>> selectedExercises) async {
    try {
      final file = File('data/program.json');

      // Read the data that are in the JSON file
      List<Map<String, dynamic>> existingWorkouts = [];
      if (await file.exists()) {
        String contents = await file.readAsString();
        if (contents.isNotEmpty) {
          if (contents.trim().startsWith('[')) {
            existingWorkouts = List<Map<String, dynamic>>.from(
              jsonDecode(contents)
            );
          } 
          // In case there is just on object in the file
          else {
            existingWorkouts = [
              Map<String, dynamic>.from(jsonDecode(contents))
            ];
          }
        }
      }

      // Assembling the workout program
      final newWorkout = {
        'workoutName': workoutName,
        'exercises': selectedExercises,
      };
      existingWorkouts.add(newWorkout);

      // Lint the JSON file 
      final JsonEncoder encoder = JsonEncoder.withIndent('  ');
      String prettyJson = encoder.convert(existingWorkouts);
      prettyJson += '\n';

      // Save with the new programm
      await file.writeAsString(prettyJson);
      print('The workout program has been correctly saved.');
      showDialog(
        context: context, 
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF242b35),
            title: Text(
              'Success',
              style: TextStyle(color: Colors.white)
            ),
            content: Text(
              'The workout program has been saved correctly.',
              style: TextStyle(color: Colors.white), 
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.blue)
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error happened during saving : $e');
    }
  }

  /**
   * @brief Recalculate the total time and calories when an exercise is removed
   */
  void _recalculateTotals() {
      _CreateWorkoutPage.totalTimeSec = 0;
      _CreateWorkoutPage.totalCalories = 0;

      for (var exercise in selectedExercises) {
        int series = exercise[setIndex] as int;
        int repetitions = exercise[repetitionsIndex] as int; 
        int restTime = exercise[restTimeIndex] as int;
        int exerciseCalories = exercise[caloriesIndex] as int;

        _CreateWorkoutPage.totalTimeSec += (((averageTimeRepet * repetitions) * series) + (series * restTime)).toInt();
        _CreateWorkoutPage.totalCalories += repetitions *  series * averageTimeRepet * exerciseCalories  ~/ 60;
      }
      totalTimeMin = totalTimeSec ~/ 60;
  }

  /**
   * @brief Reset all the variables
   *        Used when leaving the page or saving the workout program
   */
  void _resetVariables() {
    _CreateWorkoutPage.selectedExercises = [];
    _CreateWorkoutPage.totalTimeSec = 0;
    _CreateWorkoutPage.totalTimeMin = 0;
    _CreateWorkoutPage.totalCalories = 0;
  }
}