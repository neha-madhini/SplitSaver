# SplitSaver - Savings Management App

SplitSaver is a Flutter application that helps users manage their annual savings by splitting them into two components: CompA and CompB. Users can add savings, view history, and perform withdrawals while tracking balances over time.

## Project Structure

The project follows MVVM (Model-View-ViewModel) architecture with Bloc for state management and Sqflite for local storage.

lib/
│
├── main.dart                       // App entry point
│
├── main_screen/                    // Main Screen Module
│   └── ui/
│       └── main_screen.dart         // Main Screen UI
│
├── savings_entry/                  // Savings Entry Module
│   ├── ui/
│   │   └── savings_screen.dart      // Savings Screen UI
│   │
│   ├── bloc/
│   │   ├── savings_bloc.dart        // Bloc Class for Savings
│   │   ├── savings_event.dart       // Bloc Events
│   │   └── savings_state.dart       // Bloc States
│   │
│   └── model/
│       └── savings_model.dart       // Data Model for Savings
│
├── history/                        // History Module
│   └── ui/
│       └── history_screen.dart      // History Screen UI (Includes Withdraw Popup)
│
├── data/
│   └── repositories/
│       └── savings_repository.dart  // Repository for Local Storage
│
├── utils/                          // Utilities and Helpers
│   ├── colors.dart                  // App Color Palette
│   └── extensions.dart              // Common Extensions
│
└── widgets/                        // Reusable Widgets
    └── gradient_button.dart          // Custom Gradient Button

new feature ->

### UI

../feature/ui
../feature/ui/featurename -> used for creating screen for feature

### Bloc

../feature/bloc -> bloc used only for feature

### Models

../feature/models -> models used only for feature

### Common widgets

../widgets -> commonly used widgets for resuable within the app are here 

### Repository

../data/repositories -> database related repositories are added here

### Utils
../utils -> added colors, extensions-commonly used methods and colors within the app are here

## State Management

Bloc (flutter_bloc package) is used for state management due to its:

- Clear separation of UI and business logic.
- Scalability for handling complex state changes.

### Event Flow:

AddSavingsEvent - Triggered when a user adds new savings.
LoadSavingsEvent - Fetches all savings and calculates totals.
WithdrawAmountEvent - Handles withdrawals from CompA or CompB.

### State Flow:

SavingsInitial - Initial state before any action.
SavingsAddedState - After successfully adding savings.
SavingsLoadedState - When savings data is loaded and totals are calculated.
SavingsUpdatedState - After a withdrawal is successfully processed.

## Local Storage

Sqflite is used for data persistence due to its:
- Offline availability and data consistency.
- Easy integration with Flutter Bloc.

### Data Flow:

SavingsRepository handles CRUD operations for local storage.

## UI Design & Navigation

Main Screen (`main_screen.dart`):
- Displays total savings, CompA, and CompB balances.
- Updates the current balance after adding savings and updating withdrawals.

Savings Screen (`savings_screen.dart`):
- Allows users to add savings by entering an amount and choosing percentages for CompA and CompB.

Percentage Logic:

Initial Values:
CompA = 50%
CompB = 50%
Dynamic Adjustment:
When the percentage for CompA is changed, CompB is automatically updated to ensure the total is always 100%.
For example, if CompA is changed to 30%, then CompB automatically becomes 70%.
This ensures that CompA + CompB = 100% at all times.
Users can modify either percentage, and the other will adjust accordingly to maintain the total at 100%.

History Screen (`history_screen.dart`):  
- Displays a list of savings along with the withdrawal history for both CompA and CompB.  
- Each entry shows:  
    - Initial Savings for CompA and CompB.  
    - Total Withdrawn Amounts for CompA and CompB.  
    - Includes each withdrawn for CompA and CompB.  

- Sliding Interaction & Withdraw Popup:  
    - Users can slide a history entry to reveal a Withdraw Button.  
    - On clicking the button, a Withdraw Popup is shown as a slide-up modal.  
  - Withdraw Popup allows:  
        - Selecting the component (CompA or CompB) from a Dropdown.  
        - Entering the Withdrawal Amount.  
    - Validations:  
        - Ensures the amount does not exceed the Current Balance of the selected component.  
        - Shows an error message for invalid or excessive amounts.  
  - Upon successful withdrawal:  
        - The selected entry in the History Screen is updated to reflect the new balance and withdrawn amount.  
        - The Current Balance is also updated on the Main Screen.  

## Business Logic & Validations

Current Balance & Withdrawals:

Current Balance Calculation: Current Balance = Initial Savings - Total Withdrawn

Validation Rules:

Withdrawal cannot exceed the available balance in CompA or CompB.
Error messages are displayed for invalid amounts.
Balances are dynamically updated after each withdrawal.

## Dependencies

flutter_bloc: State management using Bloc pattern.
sqflite: Local storage using SQLite database.
equatable: For state comparison in Bloc.
path & path_provider: For locating and managing file paths for local storage.
flutter_slidable: Enables sliding functionality in the History Screen for the Withdraw button.
intl: For formatting dates and numbers. Used for formatting the balances shown in main and history screen.
