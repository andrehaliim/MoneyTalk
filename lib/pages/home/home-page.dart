import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_talk/color_scheme.dart';
import 'package:money_talk/models/transaction-model.dart';
import 'package:money_talk/models/transaction-services.dart';
import 'package:money_talk/pages/formatting.dart';
import 'package:money_talk/pages/transaction/transaction-all-page.dart';
import 'package:money_talk/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _transactionService = TransactionServices();
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  double _transactionBalance = 0.0;

  @override
  void initState() {
    initAllTransaction();
    super.initState();
  }

  Future<void> initAllTransaction() async {
    setState(() {
      _isLoading = true;
    });

    await _transactionService.getAllTransaction().then((value) {
      setState(() {
        _transactions = value;
        _transactionBalance = value.fold(0.0, (sum, item) => sum + (item.isIncome ? item.amount : -item.amount));
      });
    });

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20),
        child: !_isLoading ? Column(
          children: [
            _userInfo(),
            SizedBox(height: 20),
            _totalBalance(_transactionBalance),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Activity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: moneyTalkColorScheme.onTertiary,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => TransactionAllPage(transactions: _transactions)));

                  },
                  child: Text(
                    'See all',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: moneyTalkColorScheme.primary,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _activityList(),
          ],
        ) : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Row _userInfo() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.person_2_outlined, color: Colors.white,),
        ),
        SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello Andre!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: moneyTalkColorScheme.onSurface,
              ),
            ),
            Text(
              'Welcome to MoneyTalk',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: moneyTalkColorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Spacer(),
        Material(
          elevation: 1,
          shape: CircleBorder(),
          color: moneyTalkColorScheme.surface,
          child: IconButton(
            onPressed: () => log('Notification'),
            icon: Icon(Icons.notifications_outlined),
          ),
        )
      ],
    );
  }

  Container _totalBalance(double totalBalance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: totalBalance > 0 ? [
            moneyTalkColorScheme.onPrimaryContainer,
            moneyTalkColorScheme.primary,
          ] : [
            moneyTalkColorScheme.onErrorContainer,
            moneyTalkColorScheme.error,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: moneyTalkColorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rp. ${Formatting().formatRupiah(totalBalance)}',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: moneyTalkColorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: moneyTalkColorScheme.onPrimary,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                'Increase 10.5%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: moneyTalkColorScheme.onPrimary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _activityList() {
    return Expanded(
      child: DefaultWidgets().defaultContainer(
        context,
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final data = _transactions[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: data.isIncome ? moneyTalkColorScheme.primaryContainer : moneyTalkColorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        data.isIncome ? Icons.upload : Icons.download,
                        color: data.isIncome ? moneyTalkColorScheme.primary : moneyTalkColorScheme.error,
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
                      '${data.isIncome ? '+' : '-'}Rp. ${Formatting().formatRupiah(data.amount)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: data.isIncome ? moneyTalkColorScheme.primary : moneyTalkColorScheme.error,
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
        null,
        null,
      ),
    );
  }
}
