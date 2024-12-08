import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<dynamic>>? future;

  @override
  void initState() {
    super.initState();
    future = fetchCharacters();
  }

  Future<List<dynamic>> fetchCharacters() async {
    final response = await http.get(Uri.parse('https://hp-api.onrender.com/api/characters/staff'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 7 - API Calls"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final characters = snapshot.data!;
            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                return ExpandedTile(
                  title: Text(character['name'] ?? 'Unknown Name'),
                  trailing: const Icon(Icons.keyboard_arrow_down),
                  leading: Image.network(
                    character['image']?.startsWith('http') == true ? character['image']! : 'https://via.placeholder.com/50',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  content: Padding( 
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Actor: ${character['actor'] ?? 'Unknown'}'),
                        if (character['ancestry'] != null)
                          Text('Ancestry: ${character['ancestry']}'),
                        if (character['house'] != null)
                          Text('House: ${character['house']}'),
                      ],
                    ),
                  ),
                  controller: ExpandedTileController(),
                );
              },
            );
          } else {
            return const Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }
}