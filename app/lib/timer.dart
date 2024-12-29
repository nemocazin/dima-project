import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'main.dart';

class TimerPage extends StatefulWidget {
  final String workoutName;

  const TimerPage({Key? key, required this.workoutName}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  List<dynamic> exercises = [];
  int currentExerciseIndex = 0;
  int currentSet = 0;
  bool isResting = false;
  int remainingTime = 0;
  int totalTime = 0;
  bool isTimerRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadWorkoutData();
  }

  @override
  void dispose() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    super.dispose();
  }

  Future<void> loadWorkoutData() async {
    final String response = await rootBundle.loadString('data/program.json');
    final List<dynamic> data = json.decode(response);

    final workout = data.firstWhere(
      (w) => w['workoutName'] == widget.workoutName,
      orElse: () => null,
    );

    if (workout != null) {
      setState(() {
        exercises = workout['exercises'];
        totalTime = calculateTotalTime();
        remainingTime = calculateSetTime();
      });
    }
  }

  int calculateTotalTime() {
    num total = 0;
    for (var exercise in exercises) {
      total += (exercise[11] + exercise[10]*2);
    }
    return total.toInt();
  }

  int calculateSetTime() {
    if (currentExerciseIndex < exercises.length) {
      return exercises[currentExerciseIndex][9] * 3;  // Exemple de temps par set
    }
    return 0;
  }

  void startTimer() {
    if (isTimerRunning) return;

    setState(() {
      isTimerRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (totalTime > 0) {
        setState(() {
          totalTime--;
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            handleNextState();
          }
        });
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    setState(() {
      isTimerRunning = false;
    });
  }

  void handleNextState() {
    final currentExercise = exercises[currentExerciseIndex];

    if (!isResting) {
      // Si nous sommes dans un exercice et que la série est terminée
      if (currentSet < currentExercise[8]) {
        setState(() {
          currentSet++;
          remainingTime = currentExercise[10];  // Recalculer le temps de repos entre les séries
          isResting = true;  // Passage en période de repos
        });
      } else {
        // Lorsque toutes les séries de l'exercice sont terminées, passer à l'exercice suivant
        setState(() {
          currentSet = 0;  // Réinitialiser les séries pour l'exercice suivant
          // Vérifier si l'exercice suivant existe
          if (currentExerciseIndex < exercises.length - 1) {
            currentExerciseIndex++;  // Passer à l'exercice suivant
            remainingTime = calculateSetTime();  // Redémarrer le temps pour la première série de l'exercice suivant
          } else {
            stopTimer();  // Terminer l'entraînement si tous les exercices sont terminés
          }
          isResting = false;  // Éviter de démarrer un temps de repos supplémentaire ici
        });
      }
    } else {
      // Gérer le temps de repos entre les séries
      if (remainingTime == 0) {
        setState(() {
          isResting = false;  // Reprendre l'exercice après le temps de repos
          if (currentSet < currentExercise[8]) {
            remainingTime = calculateSetTime();  // Redémarrer le temps pour la prochaine série
          }
        });
      } else {
        setState(() {
          remainingTime--;  // Décrémenter le temps de repos
        });
      }
    }
  }

  // Fonction pour formater le temps en minutes et secondes (pour l'affichage seulement)
  String formatTime(int timeInSeconds) {
    int minutes = timeInSeconds ~/ 60;  // Division entière pour les minutes
    int seconds = timeInSeconds % 60;  // Reste pour les secondes
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1c1e22),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.blue.shade100,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentExercise = exercises[currentExerciseIndex];

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section avec l'exercice, série et le temps restant
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Current Exercise: ${currentExercise[1]}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Set: $currentSet / ${currentExercise[8]}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    isResting
                        ? 'Rest Time: ${formatTime(remainingTime)}'
                        : 'Time Left: ${formatTime(remainingTime)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Total Workout Time: ${formatTime(totalTime)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF242b35),
                alignment: Alignment.center,
              ),
              onPressed: () {
                if (totalTime == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MenuPage(),
                    ),
                  );
                } else {
                  if (isTimerRunning) {
                    stopTimer();
                  } else {
                    startTimer();
                  }
                }
              },
              child: Text(
                totalTime == 0
                    ? 'Return to home page'
                    : (isTimerRunning ? 'Stop Timer' : 'Start Timer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
