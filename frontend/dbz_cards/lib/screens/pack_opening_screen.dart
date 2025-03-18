// screens/pack_opening_screen.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:http/http.dart' as http;

class Character {
  final String name;
  final String imageUrl;
  final String ki;
  final String race;
  final String gender;

  Character({
    required this.name,
    required this.imageUrl,
    required this.ki,
    required this.race,
    required this.gender,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? 'Unknown',
      imageUrl: json['image'] ?? 'https://via.placeholder.com/150',
      ki: json['ki'] ?? '0',
      race: json['race'] ?? 'Unknown',
      gender: json['gender'] ?? 'Unknown',
    );
  }
}

class PackOpeningScreen extends StatefulWidget {
  const PackOpeningScreen({super.key});

  @override
  _PackOpeningScreenState createState() => _PackOpeningScreenState();
}

class _PackOpeningScreenState extends State<PackOpeningScreen> {
  Character? selectedCharacter;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool isLoading = false;

  Future<void> _openPack() async {
    setState(() {
      isLoading = true;
      selectedCharacter = null;
    });

    try {
      final character = await _fetchRandomCharacter();
      setState(() {
        selectedCharacter = character;
        cardKey.currentState?.toggleCard();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir el sobre: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<Character> _fetchRandomCharacter() async {
    final response = await http.get(Uri.parse('https://dragonball-api.com/api/characters?limit=100'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> characters = jsonData['items'];
      final randomIndex = Random().nextInt(characters.length);
      return Character.fromJson(characters[randomIndex]);
    } else {
      throw Exception('Failed to load characters: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pack Opening"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlipCard(
              key: cardKey,
              flipOnTouch: false,
              direction: FlipDirection.HORIZONTAL,
              front: GestureDetector(
                onTap: isLoading ? null : _openPack,
                child: Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: NetworkImage("https://cdn11.bigcommerce.com/s-0kvv9/images/stencil/1280w/products/155456/217236/apiyvzpo7__90284.1621358531.jpg?c=2"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Toca para abrir",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              back: GestureDetector(
                onTap: () => {
                  setState(() {
                  selectedCharacter = null;
                  cardKey.currentState?.toggleCard();
                  })
                },
                child:
                Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: NetworkImage("https://th.bing.com/th/id/OIP.NNafeFKsoK2C7XZxokP5HAHaQB?rs=1&pid=ImgDetMain"),
                      fit: BoxFit.cover
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: selectedCharacter == null
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0)
                            ),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                image: DecorationImage(
                                  image: NetworkImage(selectedCharacter!.imageUrl),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              padding: const EdgeInsets.all(12), // Padding interno
                              decoration: BoxDecoration(
                                color: Colors.grey[200], // Fondo gris claro
                                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedCharacter!.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent, // Color destacado
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Icons.bolt, color: Colors.orange, size: 20), // Ícono de poder
                                      const SizedBox(width: 8),
                                      Text(
                                        "Ki: ${selectedCharacter!.ki}",
                                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.group, color: Colors.green, size: 20), // Ícono de raza
                                      const SizedBox(width: 8),
                                      Text(
                                        "Raza: ${selectedCharacter!.race}",
                                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.person, color: Colors.purple, size: 20), // Ícono de género
                                      const SizedBox(width: 8),
                                      Text(
                                        "Género: ${selectedCharacter!.gender}",
                                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}