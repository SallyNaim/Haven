import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controllerName = TextEditingController();
  String _searchResults = '';
  List<Map<String, String>> _products = [];

  @override
  void dispose() {
    _controllerName.dispose();
    super.dispose();
  }

  void searchProduct(String name) async {
    final url = Uri.http(
        'mobile14.atwebpages.com', '/Productsearch.php', {'name': name});
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        setState(() {
          if (jsonResponse.isNotEmpty) {
            _products = List<Map<String, String>>.from(
              jsonResponse.map((item) => Map<String, String>.from(item)),
            );
            _searchResults = '';
          } else {
            _searchResults = 'No products found';
          }
        });
      } else {
        setState(() {
          _searchResults =
          'Failed to load data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _searchResults = "Error: Unable to connect. ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Product'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter product name',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                searchProduct(_controllerName.text);
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            if (_searchResults.isNotEmpty)
              Text(_searchResults,
                  style: const TextStyle(fontSize: 18, color: Colors.red)),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(_products[index]['name']!),
                      subtitle: Text('Price: \$${_products[index]['price']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
