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

  Future<User> getCurrentUser() async {
    dynamic data = await ApiService().get("/app/user/current");
    User user = User.fromJson(data['data']);
    return user;
  }

  Future<User> updateProfile(int userId, String fullName, String phone) async {
    // Make data
    Map<String, dynamic> data = {
      "id": userId,
      "fullName": fullName,
      "phone": phone,
    };
    dynamic response = await ApiService().post("/app/user/update", data);
    User user = User.fromJson(response['data']);
    return user;
  }
}
