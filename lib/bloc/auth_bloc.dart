import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Events
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent(this.username, this.password);
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String password;

  RegisterEvent(this.username, this.password);
}

class LogoutEvent extends AuthEvent {}

// States
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthFailureState extends AuthState {
  final String error;

  AuthFailureState(this.error);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FlutterSecureStorage secureStorage;
  final Map<String, String> registeredUsers = {
    // Sample registered users data
    'user1': 'password1',
    'user2': 'password2',
    'user3': 'password3',
  };


  AuthBloc(this.secureStorage) : super(AuthInitialState());

  bool isValidCredentials(String username, String password) {
    final storedPassword = registeredUsers[username];
    return storedPassword == password;
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield AuthLoadingState();

      // Simulate login API call
      await Future.delayed(Duration(seconds: 2));

      final username = event.username;
      final password = event.password;

      final isValid = isValidCredentials(username, password);
      if (isValid) {
        // Save the username in secure storage
        await secureStorage.write(key: 'username', value: username);
        yield AuthSuccessState();
      } else {
        yield AuthFailureState('Invalid username or password');
      }
    } else if (event is RegisterEvent) {
      yield AuthLoadingState();

      // Simulate registration API call
      await Future.delayed(Duration(seconds: 2));

      final username = event.username;
      final password = event.password;

      registeredUsers[username] = password;
      await secureStorage.write(key: username, value: password);

      // Save the username in secure storage
      await secureStorage.write(key: 'username', value: username);

      yield AuthSuccessState();
    } else if (event is LogoutEvent) {
      yield AuthLoadingState();

      // Simulate logout API call
      await Future.delayed(Duration(seconds: 2));

      // Clear user data from secure storage
      final username = await secureStorage.read(key: 'username');
      if (username != null) {
        await secureStorage.delete(key: username);
        await secureStorage.delete(key: 'username');
      }

      yield AuthInitialState();
    }
  }
}
