import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'color_scheme.dart';

class TranactionDetailPage extends StatefulWidget {
  const TranactionDetailPage({super.key});

  @override
  State<TranactionDetailPage> createState() => _TranactionDetailPageState();
}

class _TranactionDetailPageState extends State<TranactionDetailPage> {
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
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: moneyTalkColorScheme.primary,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Groceries',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 25,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: moneyTalkColorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.attach_money,
                              color: moneyTalkColorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shopping',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: moneyTalkColorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'Groceries - ${DateFormat('dd MMM').format(DateTime.now())}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: moneyTalkColorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '+\$85.00',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: moneyTalkColorScheme.primary,
                            ),
                          ),
                        ],
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
