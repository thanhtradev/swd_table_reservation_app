import 'package:table_reservation_app/utils/api_service.dart';

import '../models/models.dart';

class TableRepository {
  Future<List<RTable>> getTables() async {
    // Make data
    dynamic data = await ApiService().get("/app/table/all");
    List<RTable> tables =
        List.from(data['data']).map((e) => RTable.fromJson(e)).toList();
    return tables;
  }
}
