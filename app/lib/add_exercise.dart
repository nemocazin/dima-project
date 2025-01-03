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
      print('Error loading exercises: $e'); 
    }
  }

  /**
   * @brief Filter the exercises container with the string written
   */
  void filterExercisesFromString(String query) {
    setState(() {
      filteredExercisesNames = exercisesNames.where((name) {
        return name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.05; 
    double fontSize = screenHeight * 0.024; 

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
            padding: EdgeInsets.all(padding),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search exercise',
                labelStyle: TextStyle(color: Colors.white, fontSize: fontSize),
                prefixIcon: Icon(Icons.search, color: Colors.white), 
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: fontSize), 
              onChanged: filterExercisesFromString, 
            ),
          ),

          // Container with exercises
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
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
                        fontSize: fontSize, 
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseSettingPage(exerciseSelected: exercises[index+1]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(padding),
            alignment: Alignment.centerLeft,
            child: Text(
              'Filters',
              style: TextStyle(fontSize: fontSize * 1.2, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
