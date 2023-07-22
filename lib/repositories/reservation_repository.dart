import 'package:table_reservation_app/models/reservation.dart';

import '../utils/api_service.dart';

class ReservationRepository {
  Future<dynamic> bookTable(
      int tableId, DateTime startTime, int numOfPeople) async {
    Map<String, dynamic> body = {
      "tableId": tableId,
      "startTime": startTime.toIso8601String(),
      "endTime": startTime.add(const Duration(minutes: 90)).toIso8601String(),
      "partySize": numOfPeople,
    };
    // Make data
    dynamic data = await ApiService().post("/app/reservation/book", body);
    return data;
  }

  // Get reservation history by date
  Future<dynamic> getReservationHistoryByDate(DateTime date) async {
    // Convert date to dd-MM-yyyy format
    date = DateTime(date.year, date.month, date.day);
    String dateStr = "${date.day}-${date.month}-${date.year}";
    // Make data
    dynamic data =
        await ApiService().get("/app/reservation/get-by-date?dateStr=$dateStr");
    return List<Reservation>.from(
        data['data'].map((json) => Reservation.fromJson(json)));
  } // Get reservation history by date

  Future<dynamic> getReservationHistoryByDateAndUser(DateTime date) async {
    // Convert date to dd-MM-yyyy format
    date = DateTime(date.year, date.month, date.day);
    String dateStr = "${date.day}-${date.month}-${date.year}";
    // Make data
    dynamic data = await ApiService()
        .get("/app/reservation/get-by-date-and-user?dateStr=$dateStr");
    return List<Reservation>.from(
        data['data'].map((json) => Reservation.fromJson(json)));
  }

  // Update reservation status
  Future<dynamic> updateReservationStatus(
      int reservationId, String status) async {
    Map<String, dynamic> body = {
      "reservationId": reservationId,
      "status": status,
    };
    // Make data
    dynamic data = await ApiService().post("/app/reservation/update", body);
    return data;
  }
}
