///
/// @brief     Integration test file of add_exercise.dart
///
/// @author    CAZIN Némo & Adrien Paliferro
/// @date      2024 - 2025
/// 
/// Politecnico Di Milano
/// 
library DIMA;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../lib/add_exercise.dart'; 

void main() {
  group('AddExercisePage Integration Test', () {
    testWidgets('Test if exercises are loaded and displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AddExercisePage(),
      ));

      await tester.pumpAndSettle();

      /** Check if ListTile widgets are displayed */
      expect(find.byType(ListTile), findsAny);
    });


    testWidgets('Test search filter functionality', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AddExercisePage(),
      ));

      await tester.pumpAndSettle();

      /** Search for an exercise by name */
      await tester.enterText(find.byType(TextField), 'Pull-up');
      await tester.pump();

      /** Check whether the filtered exercise is displayed */
      expect(find.text('Pull-up'), findsOneWidget); 
      expect(find.text('Push-up'), findsNothing);  
    });
  });
}
