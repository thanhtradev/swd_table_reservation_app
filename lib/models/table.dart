class RTable {
  final int id;
  final int capacity;
  final bool isBooked;

  const RTable({
    required this.id,
    required this.capacity,
    required this.isBooked,
  });

  factory RTable.fromJson(Map<String, dynamic> json) {
    return RTable(
      id: json['id'],
      capacity: json['capacity'],
      isBooked: json['isBooked'] ?? json['lastCheckOut'] != null ? true : false,
    );
  }
}
