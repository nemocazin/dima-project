import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';

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
    loadExercises();
  }

  Future<void> loadExercises() async {
    try {
      final file = File('assets/exercises.csv');
      final csvData = await file.readAsString();
      setState(() {
        exercises = const CsvToListConverter().convert(csvData);
        for (int i = 1; i < exercises.length; i++) {
          exercisesNames.add(exercises[i][1].toString());
        }
        filteredExercisesNames = List.from(exercisesNames); // Initialiser la liste filtrée
      });
    } catch (e) {
      print('Error loading exercises: $e');
    }
  }

  void filterExercises(String query) {
    setState(() {
      filteredExercisesNames = exercisesNames.where((name) {
        return name.toLowerCase().startsWith(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer la hauteur de l'écran
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
                labelStyle: TextStyle(color: Colors.white), // Change la couleur du label
                prefixIcon: Icon(Icons.search, color: Colors.white), // Change la couleur de l'icône
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white), // Change la couleur du texte du champ de recherche
              onChanged: filterExercises, // Appelle la méthode pour filtrer
            ),
          ),

          // Container avec un écart et des coins arrondis
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Ajoute un écart horizontal
            child: Container(
              height: screenHeight / 2, // Fixe la hauteur à la moitié de l'écran
              decoration: BoxDecoration(
                color: const Color(0xFF242b35), // Couleur de fond pour la liste
                borderRadius: BorderRadius.circular(20.0), // Coins arrondis
              ),
              child: ListView.builder(
                itemCount: filteredExercisesNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      filteredExercisesNames[index],
                      style: TextStyle(
                        color: Colors.white,  // Couleur du texte (blanc)
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context, 
                        'exerciseSettingsPage',
                        arguments: filteredExercisesNames[index],
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
