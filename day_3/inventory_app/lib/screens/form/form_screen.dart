import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../components/custom_textfield_widget.dart';
import '../../models/item.dart';
import '../../services/item_service.dart';
import '../../utils/helper.dart';
import 'form_provider.dart';

class FormScreen extends StatefulWidget {
  final Item? itemToEdit;

  const FormScreen({super.key, this.itemToEdit});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  void showModalImagePicker(BuildContext context, FormProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Galeri"),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery, provider);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kamera"),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera, provider);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source, FormProvider provider) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final base64String = base64Encode(bytes);
        provider.setImageBase64(base64String);
      }
    } catch (e) {
      if (mounted) {
        Helper.showSnackBar(context, "Gagal mengambil gambar: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FormProvider(ItemService(), widget.itemToEdit),
      child: Consumer<FormProvider>(
        builder: (context, provider, child) {
          final isEdit = provider.isEdit;

          return Scaffold(
            appBar: AppBar(
              title: Text(isEdit ? "Edit Item" : "Tambah Item"),
              actions: [
                if (isEdit && widget.itemToEdit?.id != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: "Hapus Item",
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            final confirm = await Helper.showConfirmDialog(
                              context,
                              title: "Hapus Item",
                              message: "Apakah Anda yakin ingin menghapus item ini?",
                              confirmText: "Hapus",
                            );
                            if (confirm == true && context.mounted) {
                              try {
                                final response = await provider
                                    .deleteItem(widget.itemToEdit!.id!);
                                if (context.mounted) {
                                  Helper.showSnackBar(
                                    context,
                                    response.message ?? "Berhasil menghapus item",
                                  );
                                  Navigator.pop(context, true);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  Helper.showSnackBar(
                                    context,
                                    "Gagal menghapus: $e",
                                  );
                                }
                              }
                            }
                          },
                  ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      imagePickerField(context, provider),
                      nameField(context, provider),
                      stockField(context, provider),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final response = await provider.saveItem();
                                    if (context.mounted) {
                                      Helper.showSnackBar(
                                        context,
                                        response?.message ??
                                            (isEdit
                                                ? "Berhasil update item"
                                                : "Berhasil tambah item"),
                                      );
                                      Navigator.pop(context, true);
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      Helper.showSnackBar(
                                        context,
                                        "Gagal menyimpan: $e",
                                      );
                                    }
                                  }
                                }
                              },
                        child: provider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(isEdit ? "Update Item" : "Simpan Item"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget imagePickerField(BuildContext context, FormProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => showModalImagePicker(context, provider),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: provider.imageBase64.isNotEmpty
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        base64Decode(
                          provider.imageBase64.contains(',')
                              ? provider.imageBase64.split(',').last
                              : provider.imageBase64,
                        ),
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _buildImagePlaceholder(),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.6),
                        radius: 18,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            provider.removeImage();
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : _buildImagePlaceholder(),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
        SizedBox(height: 8),
        Text(
          "Pilih Gambar (Galeri / Kamera)",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget nameField(BuildContext context, FormProvider provider) {
    return CustomTextFieldWidget(
      labelText: "Nama Barang",
      initialValue: provider.name,
      onChanged: (value) => provider.name = value,
    );
  }

  Widget stockField(BuildContext context, FormProvider provider) {
    return CustomTextFieldWidget(
      labelText: "Stok Barang",
      keyboardType: TextInputType.number,
      initialValue: provider.stock,
      onChanged: (value) => provider.stock = value,
    );
  }
}
