import 'package:flutter_test/flutter_test.dart';
import '../../lib/create_workout.dart'; // Remplacez par le bon chemin

void main() {
  group('Tests Unitaires - CreateWorkoutPage', () {
    test('recalculateTotals should calculate total time and calories correctly', () {
      /** Simulated exercise data */
      CreateWorkoutState.selectedExercises = [
        [
          5,
          "Decline Dumbbell Press",
          "Upper Body",
          "Push",
          "Pectorals (Lower)",
          "Triceps",
          6,
          "Base",
          3,  // Series
          10, // Repetitions
          60, // RestTime
          4
        ],
        [
          5,
          "Decline Dumbbell Press",
          "Upper Body",
          "Push",
          "Pectorals (Lower)",
          "Triceps",
          6,
          "Base",
          4,  // Series
          15, // Repetitions
          45, // RestTime
          4
        ]
      ];

      /** Calculate data  */
      CreateWorkoutState().recalculateTotals();

      /** Check expected results */
      expect(CreateWorkoutState.totalTimeSec, 630); 
      expect(CreateWorkoutState.totalTimeMin, 10);  
      expect(CreateWorkoutState.totalCalories, 27);  
    });

    test('resetVariables should reset variables correctly', () {
      /** Simulating data in selectedExercises */
      CreateWorkoutState.selectedExercises = [
        ['Push-up', 3, 10, 60],
        ['Squats', 4, 15, 45],
      ];

      /** Reset variables */
      CreateWorkoutState().resetVariables();

      /** Check that variables are reset */
      expect(CreateWorkoutState.selectedExercises, []);
      expect(CreateWorkoutState.totalTimeSec, 0);
      expect(CreateWorkoutState.totalTimeMin, 0);
      expect(CreateWorkoutState.totalCalories, 0);
    });
  });
}
