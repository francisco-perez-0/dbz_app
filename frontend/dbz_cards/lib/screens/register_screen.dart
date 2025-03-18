import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  void _register() async {
    try {
      await _authService.register(
        _usernameController.text,
        _passwordController.text,
        _emailController.text,
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: Container(
          width: 300,
            height: 500,
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
            TextField(controller: _usernameController, decoration:
              InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.black87),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
                icon: Icon(
                  Icons.person
                ),
            )),
            TextField(controller: _passwordController, decoration:
              InputDecoration(
                icon: Icon(
                  Icons.password
                ),
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black87),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
                ),
                obscureText: true),
            TextField(controller: _emailController, decoration: InputDecoration(
                icon: Icon(
                  Icons.email
                ),
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black87),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
              )),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                elevation: 2,
              ),
              onPressed: _register,
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.black),
                        ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}