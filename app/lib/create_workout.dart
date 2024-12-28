import 'package:flutter/material.dart';

import 'add_exercise.dart';

class CreateWorkoutPage extends StatefulWidget {
  @override
  _CreateWorkoutPage createState() => _CreateWorkoutPage();
}

class _CreateWorkoutPage extends State<CreateWorkoutPage> {
final List<Map<String, dynamic>> exercises = [];
  int totalTime = 0;
  int totalCalories = 0;

  @override
  Widget build(BuildContext context) {
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
                        color: Color(0xFFE1E0E0), // Couleur du texte
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total calories: $totalCalories kcal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE1E0E0), // Couleur du texte
                      ),
                    ),
                  ],
                ),
                // Config button
                IconButton(
                  icon: const Icon(Icons.settings),
                  color: Colors.blue.shade100,
                  onPressed: () => _showTimerConfig(),
                ),
              ],
            ),
          ),
          
          // Scrollable exercise list
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = exercises.removeAt(oldIndex);
                  exercises.insert(newIndex, item);
                });
              },
              children: exercises.map((exercise) => 
                Card(
                  key: ValueKey(exercise['id']),
                  child: ListTile(
                    title: Text('Exercise ${exercise['id']}'),
                    trailing: const Icon(Icons.drag_handle),
                  ),
                )
              ).toList(),
            ),
          ),
          
          // Bottom buttons
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
                    onPressed: () => _saveWorkout(),
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

  void _showTimerConfig() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Timer Configuration'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Time (minutes)'),
          onChanged: (value) {
            setState(() {
              totalTime = int.tryParse(value) ?? totalTime;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _saveWorkout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Workout'),
        content: const TextField(
          decoration: InputDecoration(labelText: 'Workout Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}