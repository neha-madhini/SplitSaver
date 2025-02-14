import 'package:flutter/material.dart';
import 'package:savingsapp/utils/colors.dart';

// Custom button widget with a gradient background and rounded corners
class GradientBtton extends StatelessWidget {
  // Text to display inside the button
  final String text;

  // Constructor requiring the text to be passed
  const GradientBtton({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Button width
      height: 45, // Button height
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25), // Rounded corners
        child: Container(
          // Gradient background for the button
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                pinkGradientColor, // Starting color of the gradient
                purpleGradientColor // Ending color of the gradient
              ],
              begin: Alignment.topLeft, // Gradient starts from top-left
              end: Alignment.bottomRight, // Gradient ends at bottom-right
              stops: [0, 1], // Defines the color transition points
            ),
          ),
          child: Center(
            // Displaying the text in the center of the button
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20, // Font size for the text
                fontWeight: FontWeight.w600, // Semi-bold text style
                color: Colors.white, // White text color
              ),
            ),
          ),
        ),
      ),
    );
  }
}
