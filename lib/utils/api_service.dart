import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:table_reservation_app/utils/shared_preferences_util.dart';

class ApiService {
  static const String baseUrl = 'https://api.swd.nolamedia.tech';

  Future<dynamic> get(String endpoint) async {
    String? token = await SharedPreferencesUtil.getUserToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    if (token != null) {
      // set token to header
      final authorization = <String, String>{'Authorization': 'Bearer $token'};
      headers.addAll(authorization);
    }
    final response =
        await http.get(Uri.parse(baseUrl + endpoint), headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, dynamic data) async {
    String? token = await SharedPreferencesUtil.getUserToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    if (token != null) {
      // set token to header
      final authorization = <String, String>{'Authorization': 'Bearer $token'};
      headers.addAll(authorization);
    }
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      body: jsonEncode(data),
      headers: headers,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final responseBody = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseBody;
    } else {
      throw Exception(
          'API request failed: ${response.statusCode} - ${responseBody['message']}');
    }
  }
}
