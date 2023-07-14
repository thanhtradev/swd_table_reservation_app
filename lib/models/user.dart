import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String userName;
  final String firstName;
  final String email;
  final String phone;
  final String photoUrl;

  const User({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.email,
    required this.phone,
    required this.photoUrl,
  });

  @override
  List<Object> get props => [
        id,
        userName,
        firstName,
        email,
        phone,
        photoUrl,
      ];
  static const empty = User(
    id: 0,
    userName: '-',
    firstName: '-',
    email: '-',
    phone: '-',
    photoUrl: '-',
  );
}
