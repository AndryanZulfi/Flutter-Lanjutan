import 'package:flutter/material.dart';
import '../../models/form_request.dart';
import '../../models/form_response.dart';
import '../../models/item.dart';
import '../../services/item_service.dart';

class FormProvider extends ChangeNotifier {
  final ItemService _itemService;
  final Item? itemToEdit;

  FormProvider(this._itemService, [this.itemToEdit]) {
    if (itemToEdit != null) {
      name = itemToEdit!.name ?? '';
      stock = itemToEdit!.stock?.toString() ?? '';
      imageBase64 = itemToEdit!.imageBase64 ?? '';
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String name = '';
  String stock = '';
  String imageBase64 = '';

  void setImageBase64(String value) {
    imageBase64 = value;
    notifyListeners();
  }

  void removeImage() {
    imageBase64 = '';
    notifyListeners();
  }

  bool get isEdit => itemToEdit != null;

  Future<FormResponse?> saveItem() async {
    setIsLoading(true);
    try {
      final request = FormRequest(
        id: itemToEdit?.id,
        name: name,
        stock: int.tryParse(stock) ?? 0,
        imageBase64: imageBase64,
      );

      if (isEdit) {
        return await _itemService.updateItem(request);
      } else {
        return await _itemService.insertItem(request);
      }
    } catch (e) {
      rethrow;
    } finally {
      setIsLoading(false);
    }
  }

  Future<FormResponse> deleteItem(num id) async {
    setIsLoading(true);
    try {
      final response = await _itemService.deleteItem(id);
      notifyListeners();
      return response;
    } catch (e) {
      rethrow;
    }finally{
      setIsLoading(false);
    }
  }
}
