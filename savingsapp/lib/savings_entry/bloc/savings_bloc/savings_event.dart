part of 'savings_bloc.dart';

/// Base class for all Savings events
abstract class SavingsEvent extends Equatable {
  @override
  List<Object> get props => []; // Required for Equatable comparison
}

/// Event to add new savings
class AddSavingsEvent extends SavingsEvent {
  final double amount; // Amount to be added to savings
  final double compAPercentage; // Percentage for Component A
  final double compBPercentage; // Percentage for Component B

  // Constructor to initialize the event with necessary data
  AddSavingsEvent(this.amount, this.compAPercentage, this.compBPercentage);
}

/// Event to load all savings data
class LoadSavingsEvent extends SavingsEvent {}

/// Event to withdraw a specified amount from a component
class WithdrawAmountEvent extends SavingsEvent {
  final String component; // Specifies the component (e.g., CompA or CompB)
  final double amount; // Amount to be withdrawn
  final int id; // ID of the savings record

  // Constructor to initialize the event with required data
  WithdrawAmountEvent(this.component, this.amount, this.id);
}
