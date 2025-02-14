import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:savingsapp/utils/extensions.dart';
import '../../savings_entry/bloc/savings_bloc/savings_bloc.dart';
import '../../savings_entry/model/savings_model.dart';
import '../../utils/colors.dart';

/// HistoryScreen displays the savings history with options to view details and withdraw.
class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text('Savings History')),
      body: BlocBuilder<SavingsBloc, SavingsState>(
        builder: (context, state) {
          // Check if the savings data is loaded
          if (state is SavingsLoadedState) {
            // Display message if no savings history is available
            return state.savingsList.isEmpty
                ? Container(
                    color: lightGreyColor,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'No History Yet!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Start saving now and track your journey here.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: lightGreyColor,
                    padding: EdgeInsets.only(top: 10),
                    // Display the list of savings history
                    child: ListView.builder(
                      itemCount: state.savingsList.length,
                      itemBuilder: (context, index) {
                        final saving = state.savingsList[index];

                        // Calculate total withdrawn amount and details for CompA and CompB
                        double totalWithdrawn = saving.withdrawnCompA + saving.withdrawnCompB;
                        String withdrawnDetails = '';

                        // Format withdrawn details for CompA
                        if (saving.withdrawnCompA > 0) {
                          withdrawnDetails += 'CompA - ${saving.withdrawnCompA.formatAmount()}';
                        }
                        // Format withdrawn details for CompB
                        if (saving.withdrawnCompB > 0) {
                          if (saving.withdrawnCompA > 0) {
                            withdrawnDetails += ', ';
                          }
                          withdrawnDetails += 'CompB - ${saving.withdrawnCompB.formatAmount()}';
                        }

                        // Display each savings item with slide action for Withdraw
                        return Slidable(
                          key: const ValueKey(0), // Unique key for Slidable item
                          endActionPane: ActionPane(
                            extentRatio: 0.28,
                            motion: const ScrollMotion(),
                            children: [
                              // Slidable action for withdrawing amount
                              SlidableAction(
                                flex: 1,
                                onPressed: (context) {
                                  _showWithdrawDialog(context, saving);
                                },
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                icon: Icons.save,
                                label: 'Withdraw',
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                color: lightGreyColor,
                                child: Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  child: ListTile(
                                    // Display savings year and total amount saved
                                    title: Text('Year ${saving.year}'),
                                    subtitle: Text(
                                      'Savings - ${saving.totalSavings.formatAmount()}${totalWithdrawn > 0 ? ', Withdrawn - ${totalWithdrawn.formatAmount()} ($withdrawnDetails)' : ''}',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    ),
                  );
          } else {
            // Show loading indicator while data is being loaded
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  /// Displays a dialog for withdrawing amount from CompA or CompB
  void _showWithdrawDialog(BuildContext context, Savings savings) {
    TextEditingController amountController = TextEditingController();
    final RegExp amountRegExp = RegExp(r'^\d+(\.\d{0,2})?$');
    String selectedComponent = 'CompA';
    String? errorMessage;

    showDialog(
      context: context,
      barrierDismissible: false, // Disable dialog dismissal by tapping outside
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Withdraw Amount'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown to select CompA or CompB
                  DropdownButton<String>(
                    value: selectedComponent,
                    onChanged: (newValue) {
                      setState(() {
                        selectedComponent = newValue!;
                        errorMessage = null;
                      });
                    },
                    items: ['CompA', 'CompB'].map((component) {
                      return DropdownMenuItem(
                        value: component,
                        child: Text(component),
                      );
                    }).toList(),
                  ),
                  // Input field for entering withdrawal amount
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Enter Amount',
                      errorText: errorMessage,
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        // Allow only one dot and up to 2 decimal places
                        if (newValue.text.contains('.')) {
                          final parts = newValue.text.split('.');
                          if (parts.length > 2 || parts[1].length > 2) {
                            return oldValue;
                          }
                        }
                        return newValue;
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        errorMessage = null;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    // Cancel button to close the dialog
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    )),
                    SizedBox(width: 10),
                    // Withdraw button to proceed with the withdrawal
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          final input = amountController.text;
                          // Validate input amount
                          if (input.isEmpty || double.parse(input) == 0) {
                            errorMessage = 'Please enter an amount';
                          } else if (input.endsWith('.')) {
                            errorMessage = 'Please enter a valid number';
                          } else if (!amountRegExp.hasMatch(input)) {
                            errorMessage = 'Please enter a valid number';
                          } else {
                            double? amount = double.tryParse(amountController.text) ?? 0;
                            double availableBalance = selectedComponent == 'CompA'
                                ? savings.compA
                                : savings.compB;

                            // Check if the amount exceeds the available balance
                            if (amount > availableBalance) {
                              errorMessage = 'Amount exceeds available balance';
                            } else {
                              // Trigger withdrawal event
                              context.read<SavingsBloc>().add(
                                    WithdrawAmountEvent(selectedComponent, amount, savings.id),
                                  );
                              Navigator.pop(context);
                            }
                          }
                        });
                      },
                      child: Text('Withdraw'),
                    )),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
