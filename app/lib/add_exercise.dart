import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';

import 'exercise_settings.dart';

class AddExercisePage extends StatefulWidget {
  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  List<List<dynamic>> exercises = [];
  List<String> exercisesNames = [];
  List<String> filteredExercisesNames = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadExercisesNames();
  }

  /**
   * @brief Load all of the exercises names to show it on the app
   */
  Future<void> loadExercisesNames() async {
    try {
      final file = File('assets/exercises.csv');
      final csvData = await file.readAsString();
      setState(() {
        exercises = const CsvToListConverter().convert(csvData);
        for (int i = 1; i < exercises.length; i++) {
          exercisesNames.add(exercises[i][1].toString());
        }
        filteredExercisesNames = List.from(exercisesNames);
      });
    } catch (e) {
      print('Error loading exercises: $e'); //TODO : maybe remove or replace
    }
  }

  /**
   * @brief Filter the exercises container with the string written
   */
  void filterExercisesFromString(String query) {
    setState(() {
      filteredExercisesNames = exercisesNames.where((name) {
        return name.toLowerCase().startsWith(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1c1e22),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.blue.shade100,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFF1c1e22),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search exercise',
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search, color: Colors.white), 
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white), 
              onChanged: filterExercisesFromString, 
            ),
          ),

          // Container with exercises
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: screenHeight / 2, 
              decoration: BoxDecoration(
                color: const Color(0xFF242b35), 
                borderRadius: BorderRadius.circular(20.0), 
              ),
              child: ListView.builder(
                itemCount: filteredExercisesNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      filteredExercisesNames[index],
                      style: TextStyle(
                        color: Colors.white, 
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseSettingPage(filteredExerciseName: filteredExercisesNames[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Couleur du texte
            ),
          ),
          
        ],
      ),
    );
  }
}
