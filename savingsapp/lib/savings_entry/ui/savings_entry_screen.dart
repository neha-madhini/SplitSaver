import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/gradient_button.dart';
import '../bloc/savings_bloc/savings_bloc.dart';

// Screen for entering annual savings and splitting them into CompA and CompB
class SavingsEntryScreen extends StatefulWidget {
  @override
  _SavingsEntryScreenState createState() => _SavingsEntryScreenState();
}

class _SavingsEntryScreenState extends State<SavingsEntryScreen> {
  final _controller = TextEditingController();

  // Enhanced RegExp to allow numbers with at most two decimal places
  final RegExp amountRegExp = RegExp(r'^\d+(\.\d{0,2})?$');
  String? _errorText;
  double compAPercentage = 50; // Default split for CompA
  double compBPercentage = 50; // Default split for CompB

  // Method to update CompA percentage and adjust CompB accordingly
  void updateCompA(double value) {
    setState(() {
      compAPercentage = value;
      compBPercentage = 100 - value;
    });
  }

  // Method to update CompB percentage and adjust CompA accordingly
  void updateCompB(double value) {
    setState(() {
      compBPercentage = value;
      compAPercentage = 100 - value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Annual Savings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TextField to enter the savings amount
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                errorText: _errorText, // Displays error message if any
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                // Allows only numbers and one decimal point
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  // Custom validation to allow only one dot and up to 2 decimal places
                  if (newValue.text.contains('.')) {
                    final parts = newValue.text.split('.');
                    // If more than one dot or more than 2 decimal places, revert to old value
                    if (parts.length > 2 || parts[1].length > 2) {
                      return oldValue;
                    }
                  }
                  return newValue;
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _errorText = null; // Clear error when typing
                });
              },
            ),
            const SizedBox(height: 30),
            
            // Slider for CompA Split
            Text(
              'CompA Split (${compAPercentage.toInt()}%)',
              style: const TextStyle(fontSize: 18),
            ),
            Slider(
              value: compAPercentage,
              min: 0,
              max: 100,
              divisions: 10, // Slider steps
              label: '${compAPercentage.toInt()}%',
              onChanged: (value) {
                updateCompA(value);
              },
            ),
            const SizedBox(height: 10),
            
            // Slider for CompB Split
            Text(
              'CompB Split (${compBPercentage.toInt()}%)',
              style: const TextStyle(fontSize: 18),
            ),
            Slider(
              value: compBPercentage,
              min: 0,
              max: 100,
              divisions: 10, // Slider steps
              label: '${compBPercentage.toInt()}%',
              onChanged: (value) {
                updateCompB(value);
              },
            ),
            const SizedBox(height: 30),
            
            // Submit Button with GradientBtton widget
            Center(
              child: InkWell(
                onTap: () {
                  setState(() {
                    final input = _controller.text;
                    // Validation Rules:
                    if (input.isEmpty || double.parse(input) == 0) {
                      _errorText = 'Please enter an amount';
                    } else if (input.endsWith('.')) {
                      _errorText = 'Please enter a valid number';
                    } else if (!amountRegExp.hasMatch(input)) {
                      _errorText = 'Please enter a valid number';
                    } else {
                      _errorText = null; // Clear the error
                      final amount = double.parse(input);
                      // Triggering the AddSavingsEvent in Bloc
                      context.read<SavingsBloc>().add(AddSavingsEvent(
                          amount,
                          compAPercentage,
                          compBPercentage));
                      // Navigate back to the previous screen after successful submission
                      Navigator.pop(context, true);
                    }
                  });
                },
                child: GradientBtton(text: 'Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
