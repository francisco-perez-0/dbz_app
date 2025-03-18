import 'dart:convert';
import 'dart:ffi';

import 'package:dbz_cards/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Card {
  final int id;
  final String name;
  final String imageUrl;
  final int powerLevel;
  final String description;

  Card({required this.id, required this.name, required this.imageUrl, required this.powerLevel, required this.description});

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      powerLevel: json['powerLevel'],
      description: json['description'],
    );
  }
}

class AuthService {

  static const String url = "http://localhost:8080";
  Future<Void?> register(String username, String password, String email) async {
    final response = await http.post(
      Uri.parse('$url/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'bio': '',
        'avatar_url': '',
      }),
    );

    if(response.statusCode != 201){
      throw Exception("Error al registrar ${response.body}");
    }
    return null;
  }

  Future<String> login(String username, String password) async{
    final response = await http.post(
      Uri.parse('$url/login'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];
      // Guardar token localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return token;
    } else {
      throw Exception('Error al loguear: ${response.body}');
    }
  }

  Future<User> getProfile(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('No hay token');

    final response = await http.get(
      Uri.parse('$url/profiles/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener perfil: ${response.body}');
    }
  }

  // Nuevo método para obtener todas las cartas
  Future<List<Card>> getCards() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$url/cards'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Card.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cards');
    }
  }


  Future<void> saveCard(int cardId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('$url/profile/me/savecard'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: cardId.toString(),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to save card: ${response.body}');
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

}