import 'package:flutter/material.dart';
import 'package:recipes_app/components/item_meal_widget.dart';
import 'package:recipes_app/models/MealsResponse.dart';
import 'package:recipes_app/services/local_service.dart';
import 'package:recipes_app/services/remote_service.dart' show RemoteService;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  late Future<List<Meals>?> seafoodList;
  late Future<List<Meals>> favoriteList;

  @override
  void initState() {
    super.initState();
    seafoodList = getSeafoodList();
    refreshFavorites();
  }

  void refreshFavorites() {
    setState(() {
      favoriteList = LocalService().getListFavoriteMeal();
    });
  }

  Future<List<Meals>?> getSeafoodList() async {
    return await RemoteService().fetchMealByCategory("Seafood");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedIndex == 0 ? "Seafood Recipes" : "Favorite Recipes"),
      ),
      body: selectedIndex == 0 ? seafoodView() : favoriteView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          refreshFavorites();
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: "Seafood",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
        ],
      ),
    );
  }

  Widget seafoodView() {
    return Center(
      child: FutureBuilder<List<Meals>?>(
        future: seafoodList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(snapshot.error.toString()),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      seafoodList = getSeafoodList();
                    });
                  },
                  child: const Text("Coba Lagi"),
                )
              ],
            );
          }
          final list = snapshot.data ?? [];
          return listData(list);
        },
      ),
    );
  }

  Widget listData(List<Meals> listMeal) {
    if (listMeal.isEmpty) {
      return const Center(child: Text("Data kosong"));
    }
    return ListView.builder(
      itemCount: listMeal.length,
      itemBuilder: (context, index) {
        return ItemMealWidgets(
          meal: listMeal[index],
          onRefresh: refreshFavorites,
        );
      },
    );
  }

  Widget favoriteView() {
    return FutureBuilder<List<Meals>>(
      future: favoriteList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        final list = snapshot.data ?? [];
        if (list.isEmpty) {
          return const Center(child: Text("Belum ada resep favorit"));
        }
        return listData(list);
      },
    );
  }
}