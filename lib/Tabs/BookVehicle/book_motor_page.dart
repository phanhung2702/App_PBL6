import 'package:flutter/material.dart';

class BookMotorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Motorbike'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your motorbike type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Logic to choose scooter
              },
              child: const Text('Scooter'),
            ),
            ElevatedButton(
              onPressed: () {
                // Logic to choose sports bike
              },
              child: const Text('Sports Bike'),
            ),
            ElevatedButton(
              onPressed: () {
                // Logic to choose cruiser
              },
              child: const Text('Cruiser'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pick-up Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Select date',
                icon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Drop-off Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Select date',
                icon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to confirm booking
              },
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
