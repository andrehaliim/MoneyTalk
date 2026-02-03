import 'package:objectbox/objectbox.dart';

@Entity()
class TransactionModel {
  @Id()
  int id = 0;

  double amount;
  String categoryName;
  int categoryId;
  String note;

  @Property(type: PropertyType.date)
  DateTime date;

  bool isIncome;

  TransactionModel({
    required this.amount,
    required this.categoryName,
    required this.categoryId,
    required this.note,
    required this.date,
    required this.isIncome,
  });
}