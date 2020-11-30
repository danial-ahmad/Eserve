import 'package:flutter/material.dart';
import 'package:Eserve/catalogue/category_data.dart';
import 'package:Eserve/catalogue/category_modal.dart';
import 'package:Eserve/catalogue/food_card.dart';

class FoodCategory extends StatelessWidget {
  final List<Category> _categories = categories;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (BuildContext context, int index) {
          return FoodCard(
            categoryName: _categories[index].categoryName,
            imagePath: _categories[index].imagePath,
            number_of_item: _categories[index].number_of_item,
          );
        },
      ),
    );
  }
}
