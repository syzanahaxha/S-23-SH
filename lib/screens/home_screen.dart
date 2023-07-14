import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final AuthBloc authBloc;

  HomeScreen({required this.authBloc});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _logout() {
    widget.authBloc.add(LogoutEvent());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen(authBloc: widget.authBloc)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
            ),
            Text(
              'You are now Home',
              style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.0),
            Text(
              'All you can do there is get out',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 150,
            ),
            Container(
              width: 333.18,
              height: 61.21,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFF003D), // Set the desired color here
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
