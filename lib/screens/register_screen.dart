import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/auth_bloc.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final AuthBloc authBloc;

  const RegisterScreen({required this.authBloc});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _isButtonEnabled = false;
  File? _selectedImage;


  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_updateButtonState);
    _usernameController.addListener(_updateButtonState);
    _mobileNumberController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _mobileNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final fullName = _fullNameController.text.trim();
    final username = _usernameController.text.trim();
    final mobileNumber = _mobileNumberController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    final isEmailValid = emailRegExp.hasMatch(username);

    setState(() {
      _isButtonEnabled = fullName.isNotEmpty &&
          username.isNotEmpty &&
          isEmailValid &&
          mobileNumber.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          password == confirmPassword;
    });
  }

  void _registerUser() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Perform registration logic here using the AuthBloc or any other registration logic

    if (username.isNotEmpty && password.isNotEmpty) {
      widget.authBloc.add(RegisterEvent(username, password));
      print(username);
      _navigateToLoginScreen();
    }
    // Clear the form fields after successful registration
    _fullNameController.clear();
    _usernameController.clear();
    _mobileNumberController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreen(authBloc: widget.authBloc)),
      (route) => false,
    );
  }

  Future<void> _selectImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _navigateToLoginScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen(authBloc: widget.authBloc)),
      (route) => false,
    );
  }

  Color _strongPassword() {
    final password = _passwordController.text.trim();

    // Check if password contains numbers, letters, and has a minimum length
    final containsNumbers = RegExp(r'\d').hasMatch(password);
    final containsLetters = RegExp(r'[a-zA-Z]').hasMatch(password);
    final containsSpecialCharacters =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    final isLongEnough = password.length >= 8;

    if (containsNumbers &&
        containsLetters &&
        isLongEnough &&
        containsSpecialCharacters) {
      // Strong password: all dividers red
      return Colors.red;
    }
    return Colors.grey;
  }

  Color _3dRed() {
    final password = _passwordController.text.trim();

    // Check if password contains numbers, letters, and has a minimum length
    final isLongEnough = password.length >= 8;
    final containsNumbers = RegExp(r'\d').hasMatch(password);

    if (isLongEnough && containsNumbers) {
      // Strong password: all dividers red
      return Colors.red;
    }
    return Colors.grey;
  }

  Color _2dRed() {
    final password = _passwordController.text.trim();

    // Check if password contains numbers, letters, and has a minimum length
    final containsLetters = RegExp(r'[a-zA-Z]').hasMatch(password);
    final isLongEnough = password.length >= 8;

    if (isLongEnough && containsLetters) {
      // Strong password: all dividers red
      return Colors.red;
    }
    return Colors.grey;
  }

  Color _1stRed() {
    final password = _passwordController.text.trim();

    // Check if password contains numbers, letters, and has a minimum length
    final containsLetters = RegExp(r'[a-zA-Z]').hasMatch(password);

    if (containsLetters) {
      // Strong password: all dividers red
      return Colors.red;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        _isButtonEnabled ? Color(0xFFFF003D) : Color(0xFFDAD3D4);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 38,
                  // Add the following line to make the arrow bold
                  semanticLabel: 'Back',
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginScreen(authBloc: widget.authBloc)),
                    (route) => false,
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Register to Stree',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16.0),

              //Image Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _selectImageFromGallery,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                          child: _selectedImage == null ? Icon(Icons.add_a_photo, size: 40) : null,
                        ),
                        if (_selectedImage != null)
                          Positioned(
                            top: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: _removeImage,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              TextField(
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]+$')),
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9@.]')),
                ],
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _mobileNumberController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9+]+$')),
                ],
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 8.0),
                  Flexible(
                    child: Container(
                      height: 7.0,
                      color: _1stRed(),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Flexible(
                    child: Container(
                      height: 7.0,
                      color: _2dRed(),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Flexible(
                    child: Container(
                      height: 7.0,
                      color: _3dRed(),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Flexible(
                    child: Container(
                      height: 7.0,
                      color: _strongPassword(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _registerUser : null,
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(432.02, 54.67),
                  ),
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Color(0xFFDAD3D4);
                    }
                    return Color(0xFFFF003D);
                  }),
                ),
                child: Text('Register'),
              ),
              SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'By registering you agree to',
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        ' terms and conditions',
                        style:
                            TextStyle(color: Color(0xFFFF003D), fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'and',
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        ' Privacy policy',
                        style:
                            TextStyle(color: Color(0xFFFF003D), fontSize: 13),
                      ),
                      Text(
                        ' of the Stree',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
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
