import 'package:table_reservation_app/utils/api_service.dart';

import '../models/models.dart';

class TableRepository {
  Future<List<RTable>> getAllTables() async {
    // Make data
    dynamic data = await ApiService().get("/app/table/all");
    List<RTable> tables =
        List.from(data['data']).map((e) => RTable.fromJson(e)).toList();
    return tables;
  }

  Future<List<RTable>> getAllAvailableTable(DateTime startTime) async {
    Map<String, dynamic> body = {
      "time": startTime.toIso8601String(),
    };
    // Make data
    dynamic data = await ApiService().post("/app/table/available", body);
    List<RTable> tables =
        List.from(data['data']).map((e) => RTable.fromJson(e)).toList();
    return tables;
  }
}
