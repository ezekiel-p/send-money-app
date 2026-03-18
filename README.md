# Send Money App

A Flutter application that manages user balance and transaction history with proper state management using **BLoC**.

This app currently uses:

- `TransactionBloc` – handles loading transactions
- `TransactionRepository` – fetches transactions (from SharedPreferences / API)

---

## **Getting Started**

### **Prerequisites**

- Flutter SDK >= 3.x
- Dart >= 3.x
- Android Studio, VS Code, or any IDE supporting Flutter
- Emulator or physical device

---

## **Running the App**

1. Clone the repository:

```bash
git clone <your-repo-url>
cd send-money-app
```

2. Install dependencies:

```bash
flutter pub get
flutter run
```

## **Running Unit & Widget Tests**

```bash
flutter test
```

```bash
flutter test test/bloc/transaction_bloc_test.dart
flutter test test/widgets/primary_button_test.dart
```

## **App Architecture**

- BLoC Pattern: TransactionBloc handles transaction events and emits states
- Repository Layer: TransactionRepository fetches transactions from API or local storage
- Widgets Layer: Reusable widgets like PrimaryButton
- State Management: TransactionState tracks loading, loaded, and failure states

## **Modules**

- Transaction Module

## **Classes:**

- TransactionBloc – manages transaction events and emits states
- TransactionState – represents loading, loaded, and failure states
- TransactionRepository – fetches transactions from API or local storage
- TransactionModel – stores individual transaction information

## **Workflow:**

- App dispatches LoadTransactionsEvent
- TransactionBloc emits Status.loading
- Repository fetches transactions
- Bloc emits Status.loaded with transaction list or Status.failure if failed

## **Shared Widgets:**

- PrimaryButton – handles text, loading state, and callback
- Can be reused across screens for consistency
- Note: The PrimaryButton is used here as a reference for widget testing, but the app also contains other widgets such as BalanceCard, CustomAppBar, etc..

![Send Money Sequence Diagram](https://github.com/ezekiel-p/send-money-app/blob/main/sequence_diagram.png)
