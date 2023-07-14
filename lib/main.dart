import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'bloc/auth_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc = AuthBloc(FlutterSecureStorage());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication App',
      debugShowCheckedModeBanner: false, // Add this line to hide the debug banner

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc,
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return HomeScreen(authBloc: authBloc);
          } else {
            return LoginScreen(authBloc: authBloc);
          }
        },
      ),
    );
  }
}
