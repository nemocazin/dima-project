///
/// @brief     Page to choose the setting of the added exercise
///
/// @author    CAZIN Némo & Adrien Paliferro
/// @date      2024 - 2025
/// 
/// Politecnico Di Milano
/// 
library DIMA;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'create_workout.dart';

const int exerciseNameIndex = 1;

class ExerciseSettingPage extends StatefulWidget {
  
  const ExerciseSettingPage({
    super.key, 
    required this.exerciseSelected
  });
  
  final List<dynamic> exerciseSelected;

  @override
  ExerciseSettingPageState createState() => ExerciseSettingPageState();
}

class ExerciseSettingPageState extends State<ExerciseSettingPage> {
  final TextEditingController seriesController = TextEditingController();
  final TextEditingController repetitionsController = TextEditingController();
  final TextEditingController restTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /**
   * @brief Verify that the inputs are all correctly filled
   */
  void validateInputs() {
    if (seriesController.text.isEmpty) {
      showErrorDialog('Please fill the Series input.');
      return;
    }
    if (repetitionsController.text.isEmpty) {
      showErrorDialog('Please fill the Repetitions input.');
      return;
    }
    if (restTimeController.text.isEmpty) {
      showErrorDialog('Please fill the Rest time input.');
      return;
    }

    // Convert inputs to int
    int series = int.tryParse(seriesController.text) ?? 0;
    int repetitions = int.tryParse(repetitionsController.text) ?? 0;
    int restTime = int.tryParse(restTimeController.text) ?? 0;

    // Redirect to CreateWorkoutPage with the arguments when settings finished
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateWorkoutPage(
          exerciseData: widget.exerciseSelected,
          series: series,
          repetitions: repetitions,
          restTime: restTime,
        ),
      ),
    );
  }

  /**
   * @brief Show a dialog when a input is not filled
   * 
   * message : The message to be printed on the dialog
   */
  void showErrorDialog(String message) {
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenHeight * 0.025;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF242b35),
          title: Text(
            'Error',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: fontSize * 0.9,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.07; 
    double fontSize = screenHeight * 0.025;

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
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercice Name
            Center(
              child: Text(
                widget.exerciseSelected[exerciseNameIndex],
                style: TextStyle(
                  fontSize: fontSize * 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Options Text
            Text(
              'Choose options:',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Series Text Input
            TextField(
              controller: seriesController,
              decoration: InputDecoration(
                labelText: 'Series',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize * 0.9
                ),
                filled: true,
                fillColor: const Color(0xFF242b35),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: fontSize), 
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            // Repetitions Text Input
            TextField(
              controller: repetitionsController,
              decoration: InputDecoration(
                labelText: 'Repetitions',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize * 0.9
                ),
                filled: true,
                fillColor: const Color(0xFF242b35),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: fontSize), 
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            // Rest time Text Input
            TextField(
              controller: restTimeController,
              decoration: InputDecoration(
                labelText: 'Rest time (seconds)',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize * 0.9
                ),
                filled: true,
                fillColor: const Color(0xFF242b35),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: fontSize), 
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const Spacer(),

            // Button "Save Exercise"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF242b35),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02), 
                ),
                onPressed: validateInputs,
                child: Text(
                  'Save Exercise',
                  style: TextStyle(
                    fontSize: fontSize, 
                    backgroundColor: const Color(0xFF242b35), 
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
