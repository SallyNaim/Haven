import 'package:flutter/material.dart';
import 'Coffee.dart'; // Make sure Coffee.dart file is correctly imported

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String totalPrice = coffee.first.getTotalPrice();
  Coffee coff = coffee.first;

  // Updates the selected coffee and the total price
  void updateCoffee(Coffee coffeeItem) {
    setState(() {
      coff = coffeeItem;
      totalPrice = coffeeItem.getTotalPrice();
    });
  }

  // Updates the topping selection and total price
  void updateTopping(int topping) {
    setState(() {
      coff.topping = topping;
      totalPrice = coff.getTotalPrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Select Coffee'),
              MyDropdownMenuWidget(updateCoffee: updateCoffee), // Update widget call
              const SizedBox(height: 20),
              _buildSectionTitle('Select Topping '),
              ToppingWidget(updateTopping: updateTopping, coffee: coff), // Ensure correct widget name and parameter
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Add Sugar',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Checkbox(
                        value: coff.insurance,
                        onChanged: (bool? value) {
                          setState(() {
                            coff.insurance = value ?? false;
                            totalPrice = coff.getTotalPrice();
                          });
                        },
                      ),
                    ],
                  ),
                  Icon(
                    coff.insurance ? Icons.check_circle : Icons.info,
                    color: coff.insurance ? Colors.green : Colors.orange,
                    size: 24,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Total Price',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$$totalPrice',
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add logic for "Confirm Purchase" if needed
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order Confirmed!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Confirm Order',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
