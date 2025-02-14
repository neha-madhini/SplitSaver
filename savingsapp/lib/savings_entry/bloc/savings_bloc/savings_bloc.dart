import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/savings_repository.dart';
import '../../model/savings_model.dart';

part 'savings_event.dart';
part 'savings_state.dart';

/// Bloc class to manage savings-related events and states
class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  final SavingsRepository repository; // Repository to handle database operations

  /// Constructor to initialize the repository and set the initial state
  SavingsBloc(this.repository) : super(SavingsInitial()) {
    
    /// Event handler for adding new savings
    on<AddSavingsEvent>((event, emit) async {
      // Calculate the amounts for CompA and CompB based on percentages
      double compA = (event.compAPercentage / 100) * event.amount;
      double compB = (event.compBPercentage / 100) * event.amount;

      // Create a new Savings object with the calculated values
      Savings newSavings = Savings(
        id: DateTime.now().millisecondsSinceEpoch, // Unique ID based on timestamp
        compA: compA,
        compB: compB,
        initialCompA: compA,
        initialCompB: compB,
        totalSavings: event.amount,
        withdrawnCompA: 0.0,
        withdrawnCompB: 0.0,
        year: DateTime.now().year.toString(),
      );

      // Save the new savings entry to the database
      await repository.addSavings(newSavings);
      
      // Emit the state indicating that the savings has been added
      emit(SavingsAddedState());
    });

    /// Event handler for loading all savings from the database
    on<LoadSavingsEvent>((event, emit) async {
      // Retrieve the list of all savings
      List<Savings> savingsList = await repository.getAllSavings();

      // Calculate the total amounts for CompA and CompB
      double totalCompA = calculateTotalCompA(savingsList);
      double totalCompB = calculateTotalCompB(savingsList);

      // Emit the state with the loaded savings list and calculated totals
      emit(SavingsLoadedState(
        savingsList: savingsList,
        totalCompA: totalCompA,
        totalCompB: totalCompB,
      ));
    });

    /// Event handler for withdrawing an amount from CompA or CompB
    on<WithdrawAmountEvent>((event, emit) async {
      // Retrieve the list of all savings
      List<Savings> savingsList = await repository.getAllSavings();

      // Check if there are savings records available
      if (savingsList.isNotEmpty) {
        // Find the specific savings entry by ID
        Savings latestSavings = savingsList.firstWhere((element) => element.id == event.id); 

        // Initialize updated values
        double updatedCompA = latestSavings.compA;
        double updatedCompB = latestSavings.compB;
        double withdrawnCompA = latestSavings.withdrawnCompA;
        double withdrawnCompB = latestSavings.withdrawnCompB;

        // Update the corresponding component and withdrawal amount
        if (event.component == 'CompA') {
          updatedCompA -= event.amount;
          withdrawnCompA += event.amount;
        } else {
          updatedCompB -= event.amount;
          withdrawnCompB += event.amount;
        }

        // Create an updated Savings object
        Savings updatedSavings = Savings(
          id: latestSavings.id,
          compA: updatedCompA,
          compB: updatedCompB,
          initialCompA: latestSavings.initialCompA,
          initialCompB: latestSavings.initialCompB,
          totalSavings: latestSavings.totalSavings,
          withdrawnCompA: withdrawnCompA,
          withdrawnCompB: withdrawnCompB,
          year: latestSavings.year,
        );

        // Update the savings entry in the database
        await repository.updateSavings(updatedSavings);

        // Emit the state indicating that the savings has been updated
        emit(SavingsUpdatedState());
      }
    });
  }
  
  /// Helper method to calculate the total for CompA
  double calculateTotalCompA(List<Savings> savingsList) {
    double totalCompA = 0;
    for (var item in savingsList) {
      // Total CompA = Initial CompA - Withdrawn CompA
      totalCompA += item.initialCompA - item.withdrawnCompA;
    }
    return totalCompA;
  }

  /// Helper method to calculate the total for CompB
  double calculateTotalCompB(List<Savings> savingsList) {
    double totalCompB = 0;
    for (var item in savingsList) {
      // Total CompB = Initial CompB - Withdrawn CompB
      totalCompB += item.initialCompB - item.withdrawnCompB;
    }
    return totalCompB;
  }
}
