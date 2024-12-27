import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';

class AddExercisePage extends StatefulWidget {
  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  List<List<dynamic>> exercises = [];
  List<List<dynamic>> filteredExercises = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    try {
      final file = File('assets/exercises.csv');
      final csvData = await file.readAsString();
      setState(() {
        exercises = const CsvToListConverter().convert(csvData);
        filteredExercises = List.from(exercises);
      });
    } catch (e) {
      print('Error loading exercises: $e');
    }
  }

  void filterExercises(String query) {
    setState(() {
      filteredExercises = exercises.where((exercise) {
        final name = exercise[0].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add Exercise'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search exercise',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: filterExercises,
            ),
          ),

          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredExercises[index][0].toString()),
                  onTap: () {
                    Navigator.pushNamed(
                      context, 
                      'exerciseSettingsPage',
                      arguments: filteredExercises[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}