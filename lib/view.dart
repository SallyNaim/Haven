import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart'; // Import the Home page
import 'search.dart';

class CoffeItem {
  final String name;
  final double price;
  final String imageUrl;

  CoffeItem({required this.name, required this.price, required this.imageUrl});

  factory CoffeItem.fromJson(Map<String, dynamic> json) {
    return CoffeItem(
      name: json['name'],
      price: double.parse(json['price']),
      imageUrl: json['image_url'],
    );
  }
}

class CarListView extends StatefulWidget {
  const CarListView({super.key});

  @override
  _CarListViewState createState() => _CarListViewState();
}

class _CarListViewState extends State<CarListView> {
  late Future<List<CoffeItem>> _carItems;

  Future<List<CoffeItem>> fetchCarItems() async {
    final response = await http
        .get(Uri.parse('http://mobile14.atwebpages.com/Productget.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((car) => CoffeItem.fromJson(car)).toList();
    } else {
      throw Exception('Failed to load coffe items');
    }
  }

  @override
  void initState() {
    super.initState();
    _carItems = fetchCarItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee List'),
        actions: [
          IconButton(
            icon: Icon(Icons.local_cafe),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),

          // Add the search icon here
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to Search page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Search()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CoffeItem>>(
        future: _carItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No coffee available'));
          } else {
            final cars = snapshot.data!;
            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            car.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '\$${car.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}