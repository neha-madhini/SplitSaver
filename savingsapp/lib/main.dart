import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/savings_repository.dart';
import 'main_screen/ui/main_screen.dart';
import 'savings_entry/bloc/savings_bloc/savings_bloc.dart';

/// Entry point of the application
void main() {
  runApp(MyApp());
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  // Initializing the SavingsRepository
  final SavingsRepository repository = SavingsRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Providing multiple BLoCs to the widget tree
      providers: [
        BlocProvider<SavingsBloc>(
          create: (context) {
            // Creating SavingsBloc and triggering LoadSavingsEvent
            final bloc = SavingsBloc(repository);
            bloc.add(LoadSavingsEvent()); // Trigger the event after creation
            return bloc;
          },
        ),
        // Add more BlocProviders here if needed for other features
      ],
      child: MaterialApp(
        title: 'SplitSaver',
        theme: ThemeData(primarySwatch: Colors.blue), // App theme
        home: MainScreen(), // Entry screen of the application
        debugShowCheckedModeBanner: false, // Hides debug banner
      ),
    );
  }
}
