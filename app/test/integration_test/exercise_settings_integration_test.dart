import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/exercise_settings.dart'; // Remplacez ce chemin par le chemin correct

void main() {
  testWidgets('ExerciseSettingPage Test', (WidgetTester tester) async {
    /** A simulated selected exercise */
    List<dynamic> exerciseSelected = [
      5, 
      "Decline Dumbbell Press", // Name of the exercise
      "Upper Body", 
      "Push", 
      "Pectorals (Lower)", 
      "Triceps", 
      6, 
      "Base", 
      1, 
      1, 
      1, 
      4, 
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: ExerciseSettingPage(exerciseSelected: exerciseSelected),
      ),
    );

    /** Check that the exercise title is displayed correctly (exercise name) */
    expect(find.text('Decline Dumbbell Press'), findsOneWidget);

    /** Check that the fields are visible (Series, Repetitions, Rest time) */
    expect(find.byType(TextField), findsNWidgets(3)); // 3 fields : Sets, Repetitions, Rest time

    /** Check that the ‘Save Exercise’ button is present */
    expect(find.text('Save Exercise'), findsOneWidget);

    /** Simulate an empty field to test the error message (for example, empty Series) */
    await tester.enterText(find.byType(TextField).at(0), '');   // Series
    await tester.enterText(find.byType(TextField).at(1), '15'); // Repetitions
    await tester.enterText(find.byType(TextField).at(2), '60'); // Rest time
    await tester.tap(find.text('Save Exercise'));
    await tester.pumpAndSettle();

    /** Check whether the error dialogue appears */
    expect(find.text('Please fill the Series input.'), findsOneWidget);

    /** Fill in the input fields */
    await tester.enterText(find.byType(TextField).at(0), '3');  // Series
    await tester.enterText(find.byType(TextField).at(1), '15'); // Repetitions
    await tester.enterText(find.byType(TextField).at(2), '60'); // Rest time

    /** Press the ‘Save Exercise’ button */
    await tester.tap(find.text('Save Exercise'), warnIfMissed: false);
    await tester.pumpAndSettle();

    /** Fill in the missing field and test again */
    await tester.enterText(find.byType(TextField).at(0), '3'); // Series
    await tester.tap(find.text('Save Exercise'));
    await tester.pumpAndSettle();

  });
}
