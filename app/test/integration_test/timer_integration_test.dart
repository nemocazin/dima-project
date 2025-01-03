///
/// @brief     Integration test file of timer.dart
///
/// @author    CAZIN Némo & Adrien Paliferro
/// @date      2024 - 2025
/// 
/// Politecnico Di Milano
/// 
library DIMA;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../lib/timer.dart';

/** Simulated workout data */
final List<dynamic> simulatedWorkout = [
  {
    'workoutName': 'Test Workout',
    "exercises": <List<dynamic>>[
      <dynamic>[
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
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TimerPage Integration Tests', () {
    testWidgets('Test the complete workout flow', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: TimerPage(workoutName: "Test Workout")
      );
      
      await tester.pumpWidget(widget);
      
      /** Override the default exercises with test data */
      final TimerPageState state = tester.state(find.byType(TimerPage));
      state.setState(() { // Only works like that, even if it's a warning
        state.exercises = simulatedWorkout[0]['exercises'];
        state.initializeExercise();
      });
      
      await tester.pump();
      await tester.pumpAndSettle();

      /** Verify initial widget state */
      expect(find.text('Ready to start: Decline Dumbbell Press'), findsOneWidget);
      expect(find.text('Time Remaining: 0 seconds'), findsOneWidget);

      /** Start the workout */
      final startButton = find.widgetWithText(ElevatedButton, 'Start Workout');
      expect(startButton, findsOneWidget);
      await tester.tap(startButton);
      await tester.pump();

      /** Verify workout started */
      expect(find.text('Performing: Decline Dumbbell Press'), findsOneWidget);

      /** Stop the workout */
      final stopButton = find.widgetWithText(ElevatedButton, 'Stop Workout');
      expect(stopButton, findsOneWidget);
      await tester.tap(stopButton);
      await tester.pump();
    });

    testWidgets('Test the "End Workout" button', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: TimerPage(workoutName: "Test Workout")
      );
      
      await tester.pumpWidget(widget);
      
      /** Set test data */
      final TimerPageState state = tester.state(find.byType(TimerPage));
      state.setState(() { // Only works like that, even if it's a warning
        state.exercises = simulatedWorkout[0]['exercises'];
        state.initializeExercise();
      });
      
      await tester.pump();
      await tester.pumpAndSettle();

      /** Start and end workout */
      final startButton = find.widgetWithText(ElevatedButton, 'Start Workout');
      await tester.tap(startButton);
      await tester.pump();

      /** Test end workout if button exists */
      final endButton = find.widgetWithText(ElevatedButton, 'End Workout');
      if (endButton.evaluate().isNotEmpty) {
        await tester.tap(endButton);
        await tester.pump();
      }
    });
  });
}