import 'package:flutter/material.dart';
import 'package:money_talk/main.dart';
import 'package:money_talk/models/category-model.dart';
import 'package:money_talk/objectbox.g.dart';

class CategoryServices {
  final categoryBox = objectbox.store.box<CategoryModel>();

  Future<List<CategoryModel>> getAllCategory() async {
    return categoryBox.getAll();
  }

  Future<List<CategoryModel>> getAllCategoryIncome() async {
    return categoryBox.query(CategoryModel_.isIncome.equals(true)).build().find();
  }
  Future<List<CategoryModel>> getAllCategoryExpense() async {
    return categoryBox.query(CategoryModel_.isIncome.equals(false)).build().find();
  }

  Future<void> insertCategory(CategoryModel data) async {
    categoryBox.put(data);
  }

  Future<void> initDefaultCategories() async {
    if (!categoryBox.isEmpty()) return;

    final defaultCategories = <CategoryModel>[
      CategoryModel(
        name: 'Salary',
        iconCode: Icons.payments.codePoint,
        isIncome: true,
      ),
      CategoryModel(
        name: 'Bonus',
        iconCode: Icons.card_giftcard.codePoint,
        isIncome: true,
      ),
      CategoryModel(
        name: 'Investment',
        iconCode: Icons.trending_up.codePoint,
        isIncome: true,
      ),
      CategoryModel(
        name: 'Other Income',
        iconCode: Icons.add_circle_outline.codePoint,
        isIncome: true,
      ),
      CategoryModel(
        name: 'Food & Drink',
        iconCode: Icons.restaurant.codePoint,
        isIncome: false,
      ),
      CategoryModel(
        name: 'Transport',
        iconCode: Icons.directions_car.codePoint,
        isIncome: false,
      ),
      CategoryModel(
        name: 'Shopping',
        iconCode: Icons.shopping_bag.codePoint,
        isIncome: false,
      ),
      CategoryModel(
        name: 'Bills',
        iconCode: Icons.receipt_long.codePoint,
        isIncome: false,
      ),
      CategoryModel(
        name: 'Entertainment',
        iconCode: Icons.movie.codePoint,
        isIncome: false,
      ),
      CategoryModel(
        name: 'Health',
        iconCode: Icons.health_and_safety.codePoint,
        isIncome: false,
      ),
      CategoryModel(
        name: 'Other Expense',
        iconCode: Icons.remove_circle_outline.codePoint,
        isIncome: false,
      ),
    ];

    categoryBox.putMany(defaultCategories);
  }
}