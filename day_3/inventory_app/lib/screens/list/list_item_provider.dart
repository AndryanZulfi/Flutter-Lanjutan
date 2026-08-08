import 'package:flutter/material.dart';
import '../../models/item.dart';
import '../../models/list_item_response.dart';
import '../../services/item_service.dart';

class ListItemProvider extends ChangeNotifier {
  final ItemService _itemService;

  ListItemProvider(this._itemService);

  List<Item> _items = [];
  List<Item> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<ListItemResponse?> getListItem() async {
    setIsLoading(true);
    try {
      final response = await _itemService.getListItem();
      _items = response.data?.items ?? [];
      notifyListeners();
      return response;
    } catch (e) {
      rethrow;
    } finally {
      setIsLoading(false);
    }
  }
}
