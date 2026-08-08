import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/MealsResponse.dart';
import 'package:recipes_app/services/local_service.dart';
import 'package:recipes_app/services/remote_service.dart';

class DetailScreen extends StatefulWidget {
  final String idMeal;

  const DetailScreen({super.key, required this.idMeal});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final LocalService _localService = LocalService();
  final RemoteService _remoteService = RemoteService();

  late Future<Meals> _mealFuture;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _mealFuture = fetchMealData();
  }

  Future<Meals> fetchMealData() async {
    // 1. Cek terlebih dahulu apakah data tersimpan di LocalService (SQLite)
    final localMeal = await _localService.getMealById(widget.idMeal);
    if (localMeal != null) {
      setState(() {
        isFavorite = true;
      });
      return localMeal;
    }

    // 2. Jika belum tersimpan di local, ambil dari RemoteService (API)
    setState(() {
      isFavorite = false;
    });
    return await _remoteService.fetchMealById(widget.idMeal);
  }

  Future<void> toggleFavorite(Meals meal) async {
    if (isFavorite) {
      await _localService.deleteMeal(widget.idMeal);
      setState(() {
        isFavorite = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dihapus dari favorit")),
        );
      }
    } else {
      await _localService.insertMeal(meal);
      setState(() {
        isFavorite = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ditambahkan ke favorit")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Recipe"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Meals>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Gagal memuat detail resep: ${snapshot.error}",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _mealFuture = fetchMealData();
                      });
                    },
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          final meal = snapshot.data;
          if (meal == null) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar Resep
                Hero(
                  tag: meal.idMeal ?? widget.idMeal,
                  child: CachedNetworkImage(
                    imageUrl: meal.strMealThumb ?? "",
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Resep
                      Text(
                        meal.strMeal ?? "No Title",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // Kategori & Area
                      Row(
                        children: [
                          if (meal.strCategory != null &&
                              meal.strCategory!.isNotEmpty)
                            Chip(
                              avatar: const Icon(Icons.category, size: 16),
                              label: Text(meal.strCategory!),
                            ),
                          const SizedBox(width: 8),
                          if (meal.strArea != null && meal.strArea!.isNotEmpty)
                            Chip(
                              avatar: const Icon(Icons.public, size: 16),
                              label: Text(meal.strArea!),
                            ),
                        ],
                      ),
                      const Divider(height: 24),
                      // Instruksi Memasak
                      Text(
                        "Instruksi Memasak",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        meal.strInstructions ?? "Tidak ada instruksi.",
                        style: const TextStyle(height: 1.5, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FutureBuilder<Meals>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          final meal = snapshot.data!;
          return FloatingActionButton.extended(
            onPressed: () => toggleFavorite(meal),
            backgroundColor: isFavorite ? Colors.red : Colors.white,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.white : Colors.red,
            ),
            label: Text(
              isFavorite ? "Favorit" : "Tambah Favorit",
              style: TextStyle(
                color: isFavorite ? Colors.white : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
