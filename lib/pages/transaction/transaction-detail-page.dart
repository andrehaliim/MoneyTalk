import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_talk/models/category-model.dart';
import 'package:money_talk/models/transaction-model.dart';
import 'package:money_talk/models/transaction-services.dart';
import 'package:money_talk/pages/formatting.dart';

import '../../color_scheme.dart';

class TransactionDetailPage extends StatefulWidget {
  final CategoryModel category;
  final List<TransactionModel> transactions;
  const TransactionDetailPage({super.key, required this.category, required this.transactions});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  final List<TransactionModel> _listTransaction = [];
  final _transactionService = TransactionServices();

  @override
  void initState() {
    _listTransaction.addAll(widget.transactions);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: moneyTalkColorScheme.primary,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.category.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _listTransaction.length,
                  itemBuilder: (context, index) {
                    final data = _listTransaction[index];

                    return Dismissible(
                      key: ValueKey(data.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          _listTransaction.removeAt(index);
                          _transactionService.deleteTransaction(data.id);
                        });
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        color: moneyTalkColorScheme.surface,
                        child: Icon(Icons.delete_outline, color: Colors.red),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: widget.category.isIncome ? moneyTalkColorScheme.primaryContainer : moneyTalkColorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                widget.category.icon,
                                color: widget.category.isIncome ? moneyTalkColorScheme.primary : moneyTalkColorScheme.error,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.note,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: moneyTalkColorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd MMM').format(data.date),
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: moneyTalkColorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${widget.category.isIncome ? '+' : '-'}Rp. ${Formatting().formatRupiah(data.amount)}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: widget.category.isIncome ? moneyTalkColorScheme.primary : moneyTalkColorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
