import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class ManageWorkout extends StatefulWidget {
  @override
  _ManageWorkoutState createState() => _ManageWorkoutState();
}

class _ManageWorkoutState extends State<ManageWorkout> {
  List<Map<String, dynamic>> workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  // Charger les données depuis le fichier JSON
  Future<void> _loadWorkouts() async {
    final file = File('data/program.json');
    if (await file.exists()) {
      String contents = await file.readAsString();
      setState(() {
        workouts = List<Map<String, dynamic>>.from(json.decode(contents));
      });
    }
  }

  // Supprimer un workout et mettre à jour le fichier JSON avec une indentation correcte
  Future<void> _deleteWorkout(int index) async {
    setState(() {
      workouts.removeAt(index);
    });

    final file = File('data/program.json');
    String jsonString = json.encode(workouts, toEncodable: (dynamic nonEncodable) => nonEncodable.toString());
    
    // Indentation avec 2 espaces pour une meilleure lisibilité
    String formattedJson = const JsonEncoder.withIndent('  ').convert(json.decode(jsonString));

    await file.writeAsString(formattedJson);
  }

  // ... reste du code inchangé ...

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
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: workouts.isEmpty 
      ? Center( // Si la liste est vide, affiche le message centré
          child: Text(
            'No more workouts program',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      : ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0), // Réduit l'espace entre les éléments
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Réduit le padding vertical
              decoration: BoxDecoration(
                color: const Color(0xFF242b35),
                borderRadius: BorderRadius.circular(8), // Réduit légèrement les bords arrondis
              ),
              child: Row( // Remplace ListTile par Row pour plus de contrôle
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    workout['workoutName'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero, // Enlève le padding du bouton
                    constraints: BoxConstraints(), // Enlève les contraintes de taille minimale
                    icon: Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () => _deleteWorkout(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
}
