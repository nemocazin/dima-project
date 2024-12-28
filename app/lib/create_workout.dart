import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'add_exercise.dart';
import 'main.dart';

const int exerciseName = 1;
const int averageTimeRepet = 3;
const int caloriesIndex = 6;

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
  static int totalTime = 0;
  static int totalCalories = 0;
  static int keyIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.exerciseData != null) {
      setState(() {
        // add the settings to the exercise before being transferred to the list of selected exercise
        widget.exerciseData?.add(widget.series);
        widget.exerciseData?.add(widget.repetitions);
        widget.exerciseData?.add(widget.restTime);
        // Adding exercise to the selected list and making calculations
        selectedExercises.add(widget.exerciseData!); 
        totalTime = (((averageTimeRepet * widget.repetitions!) * widget.series!) ~/ 60).toInt();
        totalCalories = (widget.repetitions! * (widget.exerciseData?[caloriesIndex] as int? ?? 0)) * widget.series!;
      });
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Time and calories column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total time: $totalTime min',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE1E0E0),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total calories: $totalCalories kcal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE1E0E0),
                      ),
                    ),
                  ],
                ),
                // Config button
                IconButton(
                  icon: const Icon(Icons.settings),
                  color: Colors.blue.shade100,
                  onPressed: () => _showTimerDialog(),
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
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = selectedExercises.removeAt(oldIndex);
                    selectedExercises.insert(newIndex, item);
                  });
                },
                children: List.generate(selectedExercises.length, (index) {
                  final exercise = selectedExercises[index];
                  return Card(
                    key: ValueKey(keyIndex++), 
                    color: const Color(0xFF242b35),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        exercise[exerciseName],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.drag_handle,
                        color: Colors.white54,
                      ),
                    ),
                  );
                }),
              ),
            ),

          // Bottom buttons fixed at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                    child: const Text('Add Exercise'),
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
                    child: const Text('Save'),
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
   * @brief Show the timer settings 
   */
  void _showTimerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242b35),
        title: const Text(
          'Timer Configuration',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Time (minutes)',
            labelStyle: TextStyle(
              color: Colors.blue, 
            ),
          ),
          onChanged: (value) {
            setState(() {
              totalTime = int.tryParse(value) ?? totalTime;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.blue)
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
    } catch (e) {
      print('Error happened during saving : $e');
    }
  }

  /**
   * @brief Reset all the variables
   *        Used when leaving the page or saving the workout program
   */
  void _resetVariables() {
    _CreateWorkoutPage.selectedExercises = [];
    _CreateWorkoutPage.totalTime = 0;
    _CreateWorkoutPage.totalCalories = 0;
    _CreateWorkoutPage.keyIndex = 0;
  }

}

