import 'package:dbz_cards/models/user.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var id = prefs.getInt("id");
      final user = await _authService.getProfile(id!);
      setState(() => _user = user);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _addCard() async {
    setState(() => _isLoading = true);
    Navigator.pushReplacementNamed(context, '/packopening');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
            },
          ),
        ],
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                width: 500,
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
                child: Column(
                  children: [
                    Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage("https://th.bing.com/th/id/OIP.iwenvxkJAQrfj8VzhPKaRgHaEm?rs=1&pid=ImgDetMain"),
                      ),
                    ),
                    Text('Username: ${_user!.username}', style: const TextStyle(fontSize: 20)),
                    Text('Email: ${_user!.email}'),
                    Text('Bio: ${_user!.bio}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _addCard,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Add Card'),
                    ),
                  ],
              ),
              )
            ),
    );
  }
}