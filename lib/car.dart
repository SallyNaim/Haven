import 'package:flutter/material.dart';

// A constant list of car objects to populate the dropdown menu
List<Car> cars = [
  Car('Tesla Model S', 79999),
  Car('BMW 3 Series', 43900),
  Car('Audi A4', 42900),
  Car('Mercedes-Benz C-Class', 41900),
];

// Class to represent a car and calculate its total price
class Car {
  String model;
  int price;
  int warranty = 1; // Default warranty: 1 year
  bool insurance = false; // Default insurance: not included

  Car(this.model, this.price);

  @override
  String toString() {
    return '$model (\$$price)';
  }

  // Method to calculate the total price
  String getTotalPrice() {
    int insuranceAmount = insurance ? 1000 : 0;
    double multiplier = warranty == 1 ? 1.05 : 1.1;
    return (price * multiplier + insuranceAmount).toStringAsFixed(0);
  }
}

// Dropdown menu widget for car selection
class MyDropdownMenuWidget extends StatefulWidget {
  const MyDropdownMenuWidget({required this.updateCar, super.key});
  final Function(Car) updateCar;

  @override
  State<MyDropdownMenuWidget> createState() => _MyDropdownMenuWidgetState();
}

class _MyDropdownMenuWidgetState extends State<MyDropdownMenuWidget> {
  Car selectedCar = cars.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        DropdownButton<Car>(
          value: selectedCar,
          items: cars.map((Car car) {
            return DropdownMenuItem(
              value: car,
              child: Text(
                car.toString(),
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
          onChanged: (Car? car) {
            setState(() {
              if (car != null) {
                selectedCar = car;
                widget.updateCar(car);
              }
            });
          },
          isExpanded: true,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          dropdownColor: Colors.blue.shade50,
          icon: const Icon(Icons.car_rental, color: Colors.blue),
        ),
      ],
    );
  }
}

// Widget to select warranty years using radio buttons
class WarrantyWidget extends StatefulWidget {
  const WarrantyWidget({
    required this.car,
    required this.updateWarranty,
    super.key,
  });
  final Function(int) updateWarranty;
  final Car car;

  @override
  State<WarrantyWidget> createState() => _WarrantyWidgetState();
}

class _WarrantyWidgetState extends State<WarrantyWidget> {
  int selectedYears = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRadioOption('1 Year', 1),
            const SizedBox(width: 20),
            _buildRadioOption('5 Years', 5),
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
          groupValue: widget.car.warranty,
          onChanged: (int? val) {
            if (val != null) {
              setState(() {
                selectedYears = val;
                widget.updateWarranty(val);
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