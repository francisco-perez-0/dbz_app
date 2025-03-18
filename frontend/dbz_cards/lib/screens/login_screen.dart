import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    try {
      await _authService.login(_usernameController.text, _passwordController.text);
      Navigator.pushReplacementNamed(context, '/profile');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body:
        Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3)
                )
              ]
            ),
          padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(controller: _usernameController, decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  icon: Icon(
                    Icons.person,
                  ),
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.black87),
                  ),
                  cursorColor: Colors.amber,
                  ),
                TextField(controller: _passwordController, decoration:
                  InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    icon: Icon(
                      Icons.password,
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black87),
                    ),
                    cursorColor: Colors.amber,
                    obscureText: true
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    elevation: 2,
                  ),
                  onPressed: _login, child: Text(
                            'Login',
                            style: TextStyle(color: Colors.black),
                  ),
                  ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.amber,
                    elevation: 2,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
    );
  }
}