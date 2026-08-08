import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/list_item_response.dart';
import '../utils/helper.dart';
import 'endpoint.dart';

class ItemService {
  Future<ListItemResponse> getListItem() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Helper.TOKEN) ?? '';

      final response = await http.get(
        Uri.parse(Endpoint.ITEMS),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return ListItemResponse.fromRawJson(response.body);
      } else {
        try {
          return ListItemResponse.fromRawJson(response.body);
        } catch (_) {
          throw Exception(
              'Failed to fetch items (${response.statusCode}): ${response.reasonPhrase}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}