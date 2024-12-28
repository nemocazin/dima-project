import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseSettingPage extends StatefulWidget {
  final String filteredExerciseName;

  const ExerciseSettingPage({Key? key, required this.filteredExerciseName})
      : super(key: key);

  @override
  _ExerciseSettingPageState createState() => _ExerciseSettingPageState();
}

class _ExerciseSettingPageState extends State<ExerciseSettingPage> {
  final TextEditingController _seriesController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();
  final TextEditingController _restTimeController = TextEditingController();

  void _validateInputs() {
    if (_seriesController.text.isEmpty) {
      _showErrorDialog('Please fill the Series input.');
      return;
    }
    if (_repetitionsController.text.isEmpty) {
      _showErrorDialog('Please fill the Repetitions input.');
      return;
    }
    if (_restTimeController.text.isEmpty) {
      _showErrorDialog('Please fill the Rest time input.');
      return;
    }

    // Si tous les champs sont remplis
    //_showSuccessDialog();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF242b35),
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1c1e22),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.blue.shade100,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFF1c1e22),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercice Name
            Center(
              child: Text(
                widget.filteredExerciseName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Options Text
            const Text(
              'Choose options:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Series Text Input
            TextField(
              controller: _seriesController,
              decoration: InputDecoration(
                labelText: 'Series',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF242b35),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            // Repetitions Text Input
            TextField(
              controller: _repetitionsController,
              decoration: InputDecoration(
                labelText: 'Repetitions',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF242b35),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            // Rest time Text Input
            TextField(
              controller: _restTimeController,
              decoration: InputDecoration(
                labelText: 'Rest time (seconds)',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF242b35),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const Spacer(),

            // Button "Save Exercise"
            SizedBox(
              width: double.infinity, // S'adapte à la largeur de l'écran
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF242b35),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: _validateInputs,
                child: const Text(
                  'Save Exercise',
                  style: TextStyle(
                    fontSize: 16, 
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
