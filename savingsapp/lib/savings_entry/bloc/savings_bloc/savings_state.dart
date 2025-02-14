part of 'savings_bloc.dart';

/// Base class for all Savings states
abstract class SavingsState extends Equatable {
  @override
  List<Object> get props => []; // Required for Equatable comparison
}

/// Initial state when no action has been performed
class SavingsInitial extends SavingsState {}

/// State when new savings have been successfully added
class SavingsAddedState extends SavingsState {}

/// State when savings have been updated (e.g., after withdrawal)
class SavingsUpdatedState extends SavingsState {}

/// State when savings data is successfully loaded
class SavingsLoadedState extends SavingsState {
  final List<Savings> savingsList; // List of all savings records
  final double totalCompA; // Total amount in Component A
  final double totalCompB; // Total amount in Component B

  // Constructor to initialize the state with loaded data
  SavingsLoadedState({
    required this.savingsList,
    required this.totalCompA,
    required this.totalCompB,
  });

  @override
  List<Object> get props => [savingsList, totalCompA, totalCompB];
}
