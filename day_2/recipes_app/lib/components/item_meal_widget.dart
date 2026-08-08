import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/MealsResponse.dart';
import 'package:recipes_app/screens/detail_screen.dart';

class ItemMealWidgets extends StatelessWidget {
  final Meals meal;
  final VoidCallback? onRefresh;

  const ItemMealWidgets({
    super.key,
    required this.meal,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (meal.idMeal != null) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(idMeal: meal.idMeal!),
            ),
          );
          onRefresh?.call();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: meal.idMeal ?? "",
                child: CachedNetworkImage(
                  imageUrl: meal.strMealThumb ?? "",
                  height: 230.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 15,
              child: Text(
                meal.strMeal ?? "",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  shadows: [
                    Shadow(
                      offset: Offset(5.0, 4.0),
                      blurRadius: 6.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}