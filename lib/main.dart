import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/api_service.dart';
import 'repository/transaction_repository.dart';
import 'bloc/transaction/transaction_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for SharedPreferences
  final api = ApiService();
  final repo = TransactionRepository(api);

  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final TransactionRepository repo;

  const MyApp({required this.repo, super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('loggedIn') ?? false;
    if (loggedIn) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: Use MultiBlocProvider if you have multiple BLoCs
    return BlocProvider(
      create: (_) => TransactionBloc(repo),
      child: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: snapshot.data,
          );
        },
      ),
    );
  }
}
