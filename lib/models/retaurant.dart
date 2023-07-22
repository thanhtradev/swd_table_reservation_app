import 'dart:ffi';

class Restaurant {
  final Long id;
  final String name;
  final String address;
  final DateTime openTime;
  final DateTime closeTime;

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.openTime,
    required this.closeTime,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      openTime: json['openTime'],
      closeTime: json['closeTime'],
    );
  }
}
