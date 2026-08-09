import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/grid_item_widget.dart';
import '../../models/item.dart';
import '../../utils/helper.dart';
import '../auth/auth_provider.dart';
import '../auth/login_screen.dart';
import '../form/form_screen.dart';
import 'list_item_provider.dart';

class ListItemScreen extends StatefulWidget {
  const ListItemScreen({super.key});

  @override
  State<ListItemScreen> createState() => _ListItemScreenState();
}

class _ListItemScreenState extends State<ListItemScreen> {
  bool _isGrid = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AuthProvider>().loadUserName();
        context.read<ListItemProvider>().getListItem();
      }
    });
  }

  Future<void> _navigateToForm([Item? itemToEdit]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormScreen(itemToEdit: itemToEdit),
      ),
    );
    if (result == true && mounted) {
      context.read<ListItemProvider>().getListItem();
    }
  }

  Future<void> _confirmDelete(Item item) async {
    if (item.id == null) return;
    final confirm = await Helper.showConfirmDialog(
      context,
      title: "Hapus Item",
      message: "Apakah Anda yakin ingin menghapus '${item.name}'?",
      confirmText: "Hapus",
    );

    if (confirm == true && mounted) {
      try {
        final response =
            await context.read<ListItemProvider>().deleteItem(item.id!);
        if (mounted) {
          Helper.showSnackBar(
            context,
            response?.message ?? "Berhasil menghapus item",
          );
        }
      } catch (e) {
        if (mounted) {
          Helper.showSnackBar(context, "Gagal menghapus: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Text(
              authProvider.name.isNotEmpty
                  ? "Halo, ${authProvider.name}"
                  : "Daftar Item",
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            tooltip: _isGrid ? "Tampilan List" : "Tampilan Grid",
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ListItemProvider>().getListItem();
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: "Logout",
            onPressed: () async {
              final confirm = await Helper.showConfirmDialog(
                context,
                title: "Logout",
                message: "Apakah Anda yakin ingin keluar?",
                confirmText: "Logout",
              );

              if (confirm == true && context.mounted) {
                await context.read<ListItemProvider>().logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Consumer<ListItemProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.items.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.items.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => provider.getListItem(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 200),
                  Center(
                    child: Text(
                      "Data barang kosong",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.getListItem(),
            child: _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: provider.items.length,
                    itemBuilder: (context, index) {
                      final item = provider.items[index];
                      return GridItemWidget(
                        item: item,
                        onTap: () => _navigateToForm(item),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: provider.items.length,
                    itemBuilder: (context, index) {
                      final item = provider.items[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () => _navigateToForm(item),
                          contentPadding: const EdgeInsets.all(12),
                          leading: _buildItemImage(item.imageBase64),
                          title: Text(
                            item.name ?? "-",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text("Stok: ${item.stock ?? 0}"),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined,
                                    color: Colors.blue),
                                onPressed: () => _navigateToForm(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                onPressed: () => _confirmDelete(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItemImage(String? imageBase64) {
    if (imageBase64 != null && imageBase64.isNotEmpty) {
      try {
        final cleanBase64 = imageBase64.contains(',')
            ? imageBase64.split(',').last
            : imageBase64;
        final bytes = base64Decode(cleanBase64);
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            bytes,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _buildPlaceholderIcon(),
          ),
        );
      } catch (_) {
        return _buildPlaceholderIcon();
      }
    }
    return _buildPlaceholderIcon();
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        color: Colors.deepPurple,
      ),
    );
  }
}