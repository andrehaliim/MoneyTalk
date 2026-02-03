import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryModel {
  @Id()
  int id = 0;

  String name;
  int iconCode;
  bool isIncome;

  CategoryModel({
    required this.name,
    required this.iconCode,
    required this.isIncome,
  });

  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');
}