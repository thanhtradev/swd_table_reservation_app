import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:table_reservation_app/repositories/table_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<RTable> tables = [];
  @override
  void initState() {
    TableRepository tableRepository = TableRepository();
    tableRepository.getTables().then((tables) {
      setState(() {
        this.tables = tables;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(height: 20),
        const Image(image: AssetImage("assets/images/gogi.png")),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please select your table",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        // Draw the table here
        const SizedBox(height: 15),
        Expanded(
          child: GridView.count(
            crossAxisCount: 4, // Number of columns in the grid
            padding: const EdgeInsets.all(16),
            children: tables.map((table) {
              return GestureDetector(
                onTap: () {
                  // Handle table selection here
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: table.isBooked ? Colors.grey : Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Table ${table.id}',
                          style: TextStyle(
                            color: table.isBooked ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Seats: ${table.capacity}',
                          style: TextStyle(
                            color: table.isBooked ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ));
  }
}
