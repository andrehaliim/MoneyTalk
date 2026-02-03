import 'package:money_talk/main.dart';
import 'package:money_talk/models/transaction-model.dart';
import 'package:money_talk/objectbox.g.dart';

class TransactionServices {
  final transactionBox = objectbox.store.box<TransactionModel>();

  Future<List<TransactionModel>> getAllTransaction() async {
    return transactionBox.getAll();
  }

  Future<void> insertTransaction(TransactionModel data) async {
    transactionBox.put(data);
  }

  Future<List<TransactionModel>> getCategoryTransactions(int categoryId, bool isIncome) async {
    final query = transactionBox.query(TransactionModel_.categoryId.equals(categoryId)).build().find();
    return query;
  }

  Future<double> getTotalTransaction(int categoryId, bool isIncome) async {
    final query = transactionBox.query(TransactionModel_.categoryId.equals(categoryId)).build().find();
    double used = query.fold(0.0, (sum, item) => sum + (item.amount));
    return used;
  }

  Future<void> deleteTransaction(int id) async {
    transactionBox.remove(id);
  }
}