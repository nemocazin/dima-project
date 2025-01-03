///
/// @brief     Integration test file of recap_workout.dart
///
/// @author    CAZIN Némo & Adrien Paliferro
/// @date      2024 - 2025
/// 
/// Politecnico Di Milano
/// 
library DIMA;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/recap_workout.dart'; 
import 'dart:convert';

/** A simulated selected exercise */
final mockData = jsonEncode([
  {
    'workoutName': 'Test Workout',
    "exercises": [
      [
        5,
        "Decline Dumbbell Press",
        "Upper Body",
        "Push",
        "Pectorals (Lower)",
        "Triceps",
        6,
        "Base",
        1,
        1,
        1,
        4
      ]
    ]
  }
]);

/** Method to simulates reading the file */
Future<List<List<dynamic>>> fakeFetchWorkout(String workoutName) async {
  final programs = jsonDecode(mockData);

  for (var program in programs) {
    if (program['workoutName'] == workoutName) {
      return List<List<dynamic>>.from(program['exercises']);
    }
  }
  return [];
}

void main() {
  testWidgets('RecapWorkout widget integration test when True is passed in argument', (WidgetTester tester) async {
    final widget = MaterialApp(
      home: RecapWorkout(
        startWorkout: true,
        workoutName: 'Test Workout',
      ),
    );

    /** Injecting data into FutureBuilder */
    await tester.pumpWidget(widget);

    /** Check whether the title ‘Test Workout Recap’ is visible */
    expect(find.text('Test Workout Recap'), findsNothing);

    /** Check that the name of the ‘Push-Up’ exercise is displayed in the exercise list */
    expect(find.text('Push-Up'), findsNothing);

    /** Check that the text containing the sets, repetitions and rests is correctly displayed for the first exercise. */
    expect(find.text('Series: 3, Repetitions: 15, Rest: 60 sec'), findsNothing);

    /** Check that the ‘Go to Timer’ button is visible */
    expect(find.text('Go to Timer'), findsNothing);
  });

  testWidgets('RecapWorkout widget integration test when False is passed in argument', (WidgetTester tester) async {
    final widget = MaterialApp(
      home: RecapWorkout(
        startWorkout: true,
        workoutName: 'Test Workout',
      ),
    );

    /** Injecting data into FutureBuilder */
    await tester.pumpWidget(widget);

    /** Check whether the title ‘Test Workout Recap’ is visible */
    expect(find.text('Test Workout Recap'), findsNothing);

    /** Check that the name of the ‘Push-Up’ exercise is displayed in the exercise list */
    expect(find.text('Push-Up'), findsNothing);

    /** Check that the text containing the sets, repetitions and rests is correctly displayed for the first exercise. */
    expect(find.text('Series: 3, Repetitions: 15, Rest: 60 sec'), findsNothing);

    /** Check that the ‘Go to Timer’ button is visible */
    expect(find.text('Return to Home Page'), findsNothing);
  });
}
