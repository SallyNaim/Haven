import 'package:flutter/material.dart';

List<Coffee> coffee = [
  Coffee('Americano', 5),
  Coffee('Caffe Latte', 8),
  Coffee('Nescafe 3 in 1', 10),
  Coffee('Coffee Mocha', 9),
];

class Coffee {
  String model;
  int price;
  int topping = 1; // Default topping
  bool insurance = false; // Default insurance: not included

  Coffee(this.model, this.price);

  @override
  String toString() {
    return '$model (\$$price)';
  }

  // Method to calculate the total price
  String getTotalPrice() {
    int insuranceAmount = insurance ? 2 : 0;
    double multiplier = topping == 1 ? 1.05 : 1.1;
    return (price * multiplier + insuranceAmount).toStringAsFixed(0);
  }
}

// Dropdown menu widget for coffee selection
class MyDropdownMenuWidget extends StatefulWidget {
  const MyDropdownMenuWidget({required this.updateCoffee, super.key});
  final Function(Coffee) updateCoffee;

  @override
  State<MyDropdownMenuWidget> createState() => _MyDropdownMenuWidgetState();
}

class _MyDropdownMenuWidgetState extends State<MyDropdownMenuWidget> {
  Coffee selectedCoffee = coffee.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        DropdownButton<Coffee>(
          value: selectedCoffee,
          items: coffee.map((Coffee coffeeItem) {
            return DropdownMenuItem(
              value: coffeeItem,
              child: Text(
                coffeeItem.toString(),
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
          onChanged: (Coffee? coffeeItem) {
            setState(() {
              if (coffeeItem != null) {
                selectedCoffee = coffeeItem;
                widget.updateCoffee(coffeeItem);
              }
            });
          },
          isExpanded: true,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          dropdownColor: Colors.brown.shade50,
          icon: const Icon(Icons.local_cafe, color: Colors.brown),
        ),
      ],
    );
  }
}

// Widget to select toppings using radio buttons
class ToppingWidget extends StatefulWidget {
  const ToppingWidget({
    required this.coffee,
    required this.updateTopping,
    super.key,
  });
  final Function(int) updateTopping;
  final Coffee coffee;

  @override
  State<ToppingWidget> createState() => _ToppingWidgetState();
}

class _ToppingWidgetState extends State<ToppingWidget> {
  int selectedTopping = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRadioOption('Whipping Cream', 1),
            const SizedBox(width: 20),
            _buildRadioOption('Syrup of your choice', 5),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label, int value) {
    return Row(
      children: [
        Radio<int>(
          value: value,
          groupValue: widget.coffee.topping,
          onChanged: (int? val) {
            if (val != null) {
              setState(() {
                selectedTopping = val;
                widget.updateTopping(val);
              });
            }
          },
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
