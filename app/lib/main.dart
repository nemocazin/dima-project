import 'dart:convert'; // Pour convertir JSON en Map et vice-versa
import 'dart:io'; // Pour lire et écrire des fichiers
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater les dates
import 'package:flutter/services.dart'; // Pour charger les fichiers JSON

import 'create_workout.dart';
import 'schedule.dart';
import 'recap_workout.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  static String workoutName = '';
  static String startTime = '';
  static String endTime = '';

  @override
  void initState() {
    super.initState();
    // Charger les données au démarrage
    _loadWorkoutData();
  }

  // Fonction pour charger les données JSON
  Future<void> _loadWorkoutData() async {
    // Charger schedule.json et program.json
    var scheduleData = await _loadJson('data/schedule.json');
    var programData = await _loadJson('data/program.json');

    DateTime now = DateTime.now();
    String dayName = DateFormat('EEEE').format(now); // Jour actuel

    // Récupérer le programme du jour actuel
    workoutName = scheduleData[dayName] ?? 'Undefined';

    // Calculer la durée totale du workout
    int totalDurationInSeconds = _calculateTotalDuration(workoutName, programData);

    // Calculer l'heure de fin
    DateTime endDateTime = now.add(Duration(seconds: totalDurationInSeconds));

    startTime = DateFormat('HH:mm').format(now);
    endTime = DateFormat('HH:mm').format(endDateTime);

    // Rafraîchir l'interface utilisateur
    setState(() {});
  }

  // Charger un fichier JSON (avec un type dynamique)
  Future<dynamic> _loadJson(String path) async {
    // We use this technic because with JSON function, the file is stored in cache and can't be reload
    File file = File(path);
    String contents = await file.readAsString();
    return json.decode(contents); 
  }

  // Sauvegarder un fichier JSON
  Future<void> _saveJson(String path, Map<String, dynamic> data) async {
    final file = File(path);
    await file.writeAsString(jsonEncode(data));
  }

  // Calculer la durée totale d'un workout en fonction de son nom
  int _calculateTotalDuration(String workoutName, List<dynamic> programData) {
    int totalDuration = 0;
    for (var program in programData) {
      if (program['workoutName'] == workoutName) {
        for (var exercise in program['exercises']) {
          totalDuration += (exercise[11] as int); // Assurer que la durée est traitée comme un int
        }
      }
    }
    return totalDuration;
  }

  // Modifier le programme pour un jour donné
  Future<void> _updateSchedule(String day, String newWorkout) async {
    var scheduleData = await _loadJson('data/schedule.json');
    scheduleData[day] = newWorkout;

    // Sauvegarder les modifications
    await _saveJson('data/schedule.json', scheduleData);

    // Recharger les données et rafraîchir l'interface
    await _loadWorkoutData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // + Button
        leading: IconButton(
          icon: const Icon(Icons.add), 
          color: Colors.blue.shade100, 
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateWorkoutPage(
                  exerciseData: null,   // Envoie null pour exerciseData
                  series: 0,         // Envoie null pour series
                  repetitions: 0,    // Envoie null pour repetitions
                  restTime: 0,       // Envoie null pour restTime
                ),
              ),
            );
          },
        ),

        title: const Text("Menu Page"),
        centerTitle: true, 
        backgroundColor: const Color(0xFF1c1e22), 

        // Badges button   
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            color: Colors.blue.shade100,
            onPressed: () {
              // Naviguer vers badgesPage
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1c1e22), 

      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Naviguer vers recapPage
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 80, 
                backgroundColor: Colors.blue.shade100, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Actual day text
                    Text(
                      DateFormat('EEEE').format(DateTime.now()), 
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2e4b5a), 
                      ),
                    ),
                    // Actual day number text
                    Text(
                      DateFormat('d').format(DateTime.now()), 
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2e4b5a), 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), 

          // Workout of the day text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 
                Text(
                  workoutName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE1E0E0), 
                  ),
                ),
                SizedBox(height: 8),
                // Start and end times texts
                Text(
                  "Start time: $startTime",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE1E0E0),
                  ),
                ),
                Text(
                  "End time: $endTime",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE1E0E0), 
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Button for modifying the workout of the day
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF242b35),
                      alignment: Alignment.center,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutSchedulePage(),
                        ),
                      ).then((_) {
                        // Reload data each time you return to the main page
                        _loadWorkoutData();
                      });
                    },
                    child: const Text("Modify Schedule"),
                  ),
                ),
                const SizedBox(width: 16), 
                // Recap and start of the actual workout
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF242b35),
                      alignment: Alignment.center, 
                    ),
                    onPressed: () {
                      if (workoutName == 'Undefined') {
                        // Afficher un dialogue d'alerte
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFF242b35),
                              title: const Text(
                                "Attention",
                                style: TextStyle(color: Colors.white),  
                              ),
                              content: const Text(
                                "No workout selected for today ! Please select one.",
                                style: TextStyle(color: Colors.white),  
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Fermer le dialogue
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Naviguer vers RecapWorkout si un workout est défini
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecapWorkout(startWorkout: true, workoutName: workoutName),
                          ),
                        );
                      }
                    },
                    child: const Text("Start Workout"),
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