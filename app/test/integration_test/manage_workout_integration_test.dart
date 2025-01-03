///
/// @brief     Integration test file of manage_workout.dart
///
/// @author    CAZIN Némo & Adrien Paliferro
/// @date      2024 - 2025
/// 
/// Politecnico Di Milano
/// 
library DIMA;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../../lib/manage_workout.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ManageWorkout test', (tester) async {
    final testFile = File('test/test_data/test_program.json');
    await testFile.writeAsString('''[{
      "workoutName": "Test Workout",
      "exercises": 
      [[
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
      ]]
    }]''');

    await tester.pumpWidget(MaterialApp(home: ManageWorkout()));
    await tester.pumpAndSettle();

    /** Verify workout is not displayed */
    expect(find.text('Test Workout'), findsNothing);

    /** Verify empty state message */
    expect(find.text('No more workouts program'), findsOneWidget);

    /** Cleanup test file */
    await testFile.delete();
  });
}