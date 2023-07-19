class RTable {
  final int id;
  final int capacity;
  final bool isBooked;
  final DateTime? lastCheckOut;

  const RTable({
    required this.id,
    required this.capacity,
    required this.isBooked,
    this.lastCheckOut,
  });

  factory RTable.fromJson(Map<String, dynamic> json) {
    return RTable(
      id: json['id'],
      capacity: json['capacity'],
      isBooked: json['isBooked'] ?? json['lastCheckOut'] != null ? true : false,
      lastCheckOut: json['lastCheckOut'] != null
          ? DateTime.parse(json['lastCheckOut'])
          : null,
    );
  }
}
