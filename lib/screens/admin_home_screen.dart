// ignore_for_file: constant_identifier_names, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_reservation_app/repositories/reservation_repository.dart';

import '../models/reservation.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Reservation> reservations = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadReservationHistory(selectedDate);
  }

  void loadReservationHistory(DateTime date) {
    ReservationRepository().getReservationHistoryByDate(date).then((value) {
      setState(() {
        List<Reservation> sortedReservations = value;
        sortedReservations
            .sort((a, b) => b.reservationDate!.compareTo(a.reservationDate!));
        setState(() {
          reservations = sortedReservations;
        });
        reservations = sortedReservations;
      });
    });
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
      });
      loadReservationHistory(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
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
          Container(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                StatusIndicator(status: 'PENDING'),
                StatusIndicator(status: 'APPROVED'),
                StatusIndicator(status: 'REJECTED'),
                StatusIndicator(status: 'CANCELLED'),
                StatusIndicator(status: 'COMPLETED'),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                loadReservationHistory(selectedDate);
              },
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  return ReservationCard(reservation: reservations[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReservationCard extends StatefulWidget {
  final Reservation reservation;

  const ReservationCard({required this.reservation});

  @override
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  String? newStatus;

  Color getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.yellow;
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'CANCELLED':
        return Colors.grey;
      case 'COMPLETED':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormatter = DateFormat('HH:mm');
    final dateFormatter = DateFormat('EEE, MMM dd, yyyy');

    return Card(
      color: getStatusColor(widget.reservation.status!),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          _showStatusUpdateDialog(
              getAllowedStatuses(widget.reservation.status!));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Table ${widget.reservation.tableId}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.reservation.status!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Reservation Date: ${dateFormatter.format(widget.reservation.reservationDate!)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Reservation Time: ${timeFormatter.format(widget.reservation.startTime!)} - ${timeFormatter.format(widget.reservation.endTime!)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Party Size: ${widget.reservation.partySize}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> getAllowedStatuses(String currentStatus) {
    switch (currentStatus) {
      case 'PENDING':
        return ['APPROVED', 'REJECTED'];
      case 'APPROVED':
        return ['CANCELLED', 'COMPLETED'];
      default:
        return [];
    }
  }

  Future<void> _showStatusUpdateDialog(List<String> allowedStatuses) async {
    final newStatus = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var status in allowedStatuses)
                ListTile(
                  title: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(status),
                ),
            ],
          ),
        );
      },
    );

    if (newStatus != null) {
      setState(() {
        this.newStatus = newStatus;
      });
      ReservationRepository()
          .updateReservationStatus(widget.reservation.id!, newStatus)
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reservation status updated successfully!'),
          ),
        );
        // Make screen refresh
        setState(() {});
      });
    }
  }
}

class StatusIndicator extends StatelessWidget {
  final String status;

  const StatusIndicator({required this.status});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.yellow;
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'CANCELLED':
        return Colors.grey;
      case 'COMPLETED':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'PENDING':
        return 'Pending';
      case 'APPROVED':
        return 'Approved';
      case 'REJECTED':
        return 'Rejected';
      case 'CANCELLED':
        return 'Cancelled';
      case 'COMPLETED':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getStatusColor(status),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _getStatusText(status),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
