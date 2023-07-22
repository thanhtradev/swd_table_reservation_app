// Generate model from
/**
 * "id": 1,
  "userId": 3,
  "tableId": 1,
  "reservationDate": "2023-07-22T01:39:54.430+00:00",
  "startTime": "2023-07-22T09:30:00.000+00:00",
  "endTime": "2023-07-22T11:00:00.000+00:00",
  "partySize": 2,
  "status": "APPROVED"
 */

class Reservation {
  int? id;
  int? userId;
  int? tableId;
  DateTime? reservationDate;
  DateTime? startTime;
  DateTime? endTime;
  int? partySize;
  String? status;

  Reservation(
      {this.id,
      this.userId,
      this.tableId,
      this.reservationDate,
      this.startTime,
      this.endTime,
      this.partySize,
      this.status});

  Reservation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    tableId = json['tableId'];
    reservationDate = DateTime.parse(json['reservationDate']);
    startTime = DateTime.parse(json['startTime']);
    endTime = DateTime.parse(json['endTime']);
    partySize = json['partySize'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'tableId': tableId,
      'reservationDate': reservationDate!.toIso8601String(),
      'startTime': startTime!.toIso8601String(),
      'endTime': endTime!.toIso8601String(),
      'partySize': partySize,
      'status': status,
    };
  }
}
