///
/// @brief     Integration test file of create_workout.dart
///
/// @author    CAZIN Némo & Adrien Paliferro
/// @date      2024 - 2025
/// 
/// Politecnico Di Milano
/// 
library DIMA;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/create_workout.dart';

void main() {
  testWidgets('CreateWorkoutPage No Exercise', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CreateWorkoutPage(),
    ));

    /** Check that the page loads correctly with the title ‘No exercises selected!’ */
    expect(find.text('No exercises selected!'), findsOneWidget);
    
    /** Check that the totals (time and calories) are present with their base values */
    expect(find.text('Total time: 0 min'), findsOneWidget);
    expect(find.text('Total calories: 0 kcal'), findsOneWidget);

    /** Simulate tapping the "Save" button without any exercise selected */
    await tester.tap(find.text("Save"));
    await tester.pumpAndSettle();

    /** Expect an alert dialog to appear */
    expect(find.text("Please select an exercise!"), findsOneWidget);
    
    /** Tap OK on the dialog */
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();

    /** Add an exercise by simulating a click on the ‘Add Exercise’ button  */
    await tester.tap(find.text('Add Exercise'));
    await tester.pumpAndSettle();

    /** Check that there is an exercise */
    expect(find.text('No exercises selected!'), findsNothing); 

    /** Check that the totals (time and calories) are no longer there */
    expect(find.text('Total time: 0 min'), findsNothing);
    expect(find.text('Total calories: 0 kcal'), findsNothing);
  });
}
