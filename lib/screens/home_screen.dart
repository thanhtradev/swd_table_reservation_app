import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_reservation_app/repositories/reservation_repository.dart';
import '../models/models.dart';
import 'package:table_reservation_app/repositories/table_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<DateTime> generateTimeSlots(DateTime initialTime) {
  final List<DateTime> timeSlots = [];
  final DateTime now = initialTime;
  final DateTime startTime = DateTime(
      now.year, now.month, now.day, now.hour, now.minute < 30 ? 30 : 60);
  final DateTime endTime =
      DateTime(now.year, now.month, now.day, 22, 0); // End at 10:00 PM

  DateTime currentTime = startTime;
  currentTime = currentTime.add(const Duration(minutes: 30));
  while (currentTime.isBefore(endTime)) {
    timeSlots.add(currentTime);
    currentTime = currentTime.add(const Duration(minutes: 30));
  }
  return timeSlots;
}

class _HomeScreenState extends State<HomeScreen> {
  List<RTable> tables = [];
  DateTime selectedDate = DateTime.now();
  List<DateTime> timeSlots = generateTimeSlots(DateTime.now());
  DateTime selectedTimeSlot = generateTimeSlots(DateTime.now())[0];
  int numberOfPeople = 1;

  @override
  void initState() {
    TableRepository tableRepository = TableRepository();
    tableRepository.getAllAvailableTable(selectedTimeSlot).then((tables) {
      setState(() {
        this.tables = tables;
      });
    });
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Generate time slots from 8 am of selected date
        timeSlots = generateTimeSlots(DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day, 8, 0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please select your table",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => _selectDate(context),
                child: const Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                DateFormat('EEE, MMM dd, yyyy').format(selectedDate),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // A horizontal list show time slots, each time slot is a button, each button has a text, each time slot has a boolean property called isSelected
        // Each time slot duration is 30 minutes
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...timeSlots.map((timeSlot) {
                return buildTimeSlot(timeSlot);
              }).toList(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // A + and - button to increase and decrease the number of people
        // A text to show the number of people
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Number of people:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 15),
            IconButton(
              onPressed: () {
                if (numberOfPeople > 1) {
                  setState(() {
                    numberOfPeople--;
                  });
                }
              },
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: 15),
            Text(
              numberOfPeople.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 15),
            IconButton(
              onPressed: () {
                if (numberOfPeople < 10) {
                  setState(() {
                    numberOfPeople++;
                  });
                }
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),

        // Draw the table here
        Expanded(
          child: GridView.count(
            crossAxisCount: 4, // Number of columns in the grid
            padding: const EdgeInsets.all(5),
            children: tables.map((table) {
              return buildTableItem(context, table);
            }).toList(),
          ),
        ),
      ],
    ));
  }

  GestureDetector buildTableItem(BuildContext context, RTable table) {
    return GestureDetector(
      onTap: () {
        // Show dialog to confirm booking
        if (numberOfPeople <= table.capacity) {
          showDialog(
            context: context,
            builder: (context) {
              var people = numberOfPeople > 1 ? "peoples" : "people";
              return AlertDialog(
                title: const Text('Confirm Booking'),
                content: Text(
                    'Are you sure you want to book table ${table.id} at ${DateFormat('HH:mm').format(selectedTimeSlot)} for $numberOfPeople $people ?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      ReservationRepository()
                          .bookTable(table.id, selectedTimeSlot, numberOfPeople)
                          .then((value) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Table ${table.id} is booked at ${DateFormat('HH:mm').format(selectedTimeSlot)}'),
                          ),
                        );
                      });
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: table.isBooked
              ? Colors.grey
              : numberOfPeople <= table.capacity
                  ? Colors.green
                  : Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Table ${table.id}',
                style: TextStyle(
                  color: table.isBooked
                      ? Colors.white
                      : numberOfPeople <= table.capacity
                          ? Colors.black
                          : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Seats: ${table.capacity}',
                style: TextStyle(
                  color: table.isBooked
                      ? Colors.white
                      : numberOfPeople <= table.capacity
                          ? Colors.black
                          : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTimeSlot(DateTime timeSlot) {
    final timeFormatter = DateFormat(
        'HH:mm'); // 24-hour format "HH:mm" or 12-hour format "hh:mm a"
    String formattedTime = timeFormatter.format(timeSlot);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          TableRepository().getAllAvailableTable(timeSlot).then((tables) {
            setState(() {
              this.tables = tables;
            });
          });
          setState(() {
            selectedTimeSlot = timeSlot;
          });
        },
        child: Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: timeSlot == selectedTimeSlot ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              formattedTime,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
