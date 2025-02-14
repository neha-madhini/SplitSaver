// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savingsapp/utils/extensions.dart';
import 'package:savingsapp/widgets.dart/gradient_button.dart';
import '../../history_screen/ui/history_screen.dart';
import '../../savings_entry/bloc/savings_bloc/savings_bloc.dart';
import '../../savings_entry/ui/savings_entry_screen.dart';
import '../../utils/colors.dart';

// MainScreen widget to display the savings dashboard
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SplitSaver')),
      
      // Using BlocConsumer to listen to SavingsBloc state changes and build UI accordingly
      body: BlocConsumer<SavingsBloc, SavingsState>(
        
        // Listener to reload savings data when savings are added or updated
        listener: (context, state) {
          if (state is SavingsAddedState || state is SavingsUpdatedState) {
            context.read<SavingsBloc>().add(LoadSavingsEvent());
          }
        },

        // Builder to display UI based on the current state of SavingsBloc
        builder: (context, state) {
          if (state is SavingsLoadedState) {
            return Container(
              color: lightGreyColor, 
              padding: EdgeInsets.only(top: 10),
              
              // Displaying the main content in a Column layout
              child: Column(
                children: [
                  // Row to display CompA and CompB balance cards horizontally
                  Row(
                    children: [
                      SizedBox(width: 5),
                      
                      // Card showing CompA balance
                      Expanded(
                        child: Container(
                          color: lightGreyColor,
                          height: 100,
                          child: Card(
                            color: whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Rounded corners for card
                            ),
                            elevation: 3, // Shadow for card
                            child: ListTile(
                              title: Text('CompA Balance'),
                              // Displaying CompA balance using formatted amount
                              subtitle: Text(state.totalCompA.formatAmount().toString()),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      
                      // Card showing CompB balance
                      Expanded(
                        child: Container(
                          color: lightGreyColor,
                          height: 100,
                          child: Card(
                            color: whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Rounded corners for card
                            ),
                            elevation: 3, // Shadow for card
                            child: ListTile(
                              title: Text('CompB Balance'),
                              // Displaying CompB balance using formatted amount
                              subtitle: Text(state.totalCompB.formatAmount().toString()),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                    ]
                  ),
                  SizedBox(height: 20),
                  
                  // Button to navigate to Savings Entry Screen
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SavingsEntryScreen()),
                      );
                    },
                    child: GradientBtton(text: 'Add Savings'),
                  ),
                  
                  SizedBox(height: 20),

                  // Button to navigate to History Screen
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HistoryScreen()),
                      );
                    },
                    child: GradientBtton(text: 'History')
                  ),
                ],
              )
            );
          }

          // Showing loading indicator when state is not loaded
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
