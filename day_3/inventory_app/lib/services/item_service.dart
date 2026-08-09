import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/form_request.dart';
import '../models/form_response.dart';
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

  Future<FormResponse> insertItem(FormRequest request) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Helper.TOKEN) ?? '';

      final response = await http.post(
        Uri.parse(Endpoint.ITEMS),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: request.toRawJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FormResponse.fromRawJson(response.body);
      } else {
        try {
          return FormResponse.fromRawJson(response.body);
        } catch (_) {
          throw Exception(
              'Failed to insert item (${response.statusCode}): ${response.reasonPhrase}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<FormResponse> updateItem(FormRequest request) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Helper.TOKEN) ?? '';

      final response = await http.put(
        Uri.parse('${Endpoint.ITEMS}/${request.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: request.toRawJson(),
      );

      if (response.statusCode == 200) {
        return FormResponse.fromRawJson(response.body);
      } else {
        try {
          return FormResponse.fromRawJson(response.body);
        } catch (_) {
          throw Exception(
              'Failed to update item (${response.statusCode}): ${response.reasonPhrase}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<FormResponse> deleteItem(num id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Helper.TOKEN) ?? '';

      final response = await http.delete(
        Uri.parse('${Endpoint.ITEMS}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return FormResponse.fromRawJson(response.body);
      } else {
        try {
          return FormResponse.fromRawJson(response.body);
        } catch (_) {
          throw Exception(
              'Failed to delete item (${response.statusCode}): ${response.reasonPhrase}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}