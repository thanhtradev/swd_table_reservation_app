import 'package:table_reservation_app/models/user.dart';
import 'package:table_reservation_app/utils/api_service.dart';

class UserRepository {
  Future<User> login(String username, String password) async {
    // Make data
    Map<String, String> data = {
      "username": username,
      "password": password,
    };
    User user = await ApiService().post("/app/auth/login", data);
    return user;
  }
}
