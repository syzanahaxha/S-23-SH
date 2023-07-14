import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthBloc authBloc;

  const LoginScreen({required this.authBloc});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _showErrorMessage = false;


  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isButtonEnabled = email.isNotEmpty && password.isNotEmpty;
    });
  }

  void _navigateToHomeScreen() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Check if the user credentials are valid
    final isValidCredentials =
        widget.authBloc.isValidCredentials(username, password);
    if (isValidCredentials) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(authBloc: widget.authBloc)),
      );
    } else {
      setState(() {
        _showErrorMessage = true;
      });
      _usernameController.clear();
      _passwordController.clear();
    }
  }

  void _navigateToRegisterScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => RegisterScreen(authBloc: widget.authBloc)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        _isButtonEnabled ? Color(0xFFFF003D) : Color(0xFFDAD3D4);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 170, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 230,
                height: 78,
                alignment: Alignment.topCenter,
                child: RichText(
                  overflow: TextOverflow.visible,
                  text: TextSpan(
                    text: 'stree',
                    style: TextStyle(
                      color: Color(0xFFFF003D),
                      fontSize: 60.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60.0),
              if (_showErrorMessage)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Email and password do not match.',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              SizedBox(height: 16,),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email ID',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: null,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0xFFFC055E),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _navigateToHomeScreen : null,
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(445.96, 54.67),
                  ),
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Color(0xFFDAD3D4);
                    }
                    return Color(0xFFFF003D);
                  }),
                ),
                child: Text('Login'),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IgnorePointer(
                    ignoring: true,
                    child: TextButton(
                      onPressed: null,
                      style: TextButton.styleFrom(
                        primary: buttonColor,
                      ),
                      child: Text('Don\'t have an account?'),
                    ),
                  ),
                  TextButton(
                    onPressed: _navigateToRegisterScreen,
                    child: Text(
                      'Register Now',
                      style: TextStyle(
                        color: Color(0xFFFC055E),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
