import 'package:dbz_cards/models/user.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

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
    try {
      final user = await _authService.getProfile(44);
      setState(() => _user = user);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _addCard() async {
    setState(() => _isLoading = true);
    try {
      const cardId = 1;


      await _authService.saveCard(cardId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card added to your collection!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding card: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            ),
    );
  }
}