import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Nécessaire pour formater les dates

import 'create_workout.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenir la date actuelle
    DateTime now = DateTime.now();
    String dayName = DateFormat('EEEE').format(now); // Nom du jour (ex : Monday)
    String dayNumber = DateFormat('d').format(now);  // Numéro du jour (ex : 14)

    return Scaffold(
      appBar: AppBar(
        // + Button
        leading: IconButton(
          icon: const Icon(Icons.add), 
          color: Colors.blue.shade100, 
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateWorkoutPage()),
            );
          },
        ),

        title: const Text("Menu Page"),
        centerTitle: true, // Centre le texte de l'AppBar
        backgroundColor: const Color(0xFF1c1e22), // Couleur de l'AppBar   

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
      backgroundColor: const Color(0xFF1c1e22), // Couleur de l'arrière-plan

      body: Column(
        children: [
          // Texte du jour dans un cercle
          GestureDetector(
            onTap: () {
              // Naviguer vers recapPage
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 80, // Taille du cercle
                backgroundColor: Colors.blue.shade100, // Couleur de fond
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName, // Jour actuel (ex : Monday)
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2e4b5a), // Couleur du texte
                      ),
                    ),
                    Text(
                      dayNumber, // Numéro actuel (ex : 14)
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2e4b5a), // Couleur du texte
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Espacement
          // Informations sur le Workout
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Workout Name",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE1E0E0), // Couleur du texte
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Start time: 17:00",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE1E0E0), // Couleur du texte
                  ),
                ),
                Text(
                  "End time: 19:00",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE1E0E0), // Couleur du texte
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
          // Boutons Modifier et Démarrer Workout
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF242b35), 
                      alignment: Alignment.center, // Centre le texte
                    ),
                    onPressed: () {
                      // Logique pour modifier l'horaire
                    },
                    child: const Text("Modify Schedule"),
                  ),
                ),
                const SizedBox(width: 16), 
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF242b35),
                      alignment: Alignment.center, 
                    ),
                    onPressed: () {
                      // Naviguer vers timerPage
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
