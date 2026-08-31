import 'package:flutter/material.dart';
import 'state/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Central App State initialized here
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, child) {
        return MaterialApp(
          title: 'Abhiyant - Farmer Procurement App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF0F5A24),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F5A24),
              primary: const Color(0xFF0F5A24),
              secondary: const Color(0xFF2E7D32),
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
          ),
          home: _appState.isAuthenticated
              ? DashboardScreen(
                  appState: _appState,
                  onLogout: () {
                    setState(() {
                      _appState.logout();
                    });
                  },
                )
              : LoginScreen(
                  appState: _appState,
                  onLoginSuccess: () {
                    setState(() {});
                  },
                ),
        );
      },
    );
  }
}
