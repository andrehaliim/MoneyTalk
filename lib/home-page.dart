import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_talk/color_scheme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:20),
        child: Column(
          children: [
            _userInfo(),
            SizedBox(height: 20),
            _totalBalance(),
            SizedBox(height: 20),
            _activity(),
          ],
        ),
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

  Container _totalBalance() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            moneyTalkColorScheme.onPrimaryContainer,
            moneyTalkColorScheme.primary,
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
          Row(
            children: [
              Text(
                'Total Balance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: moneyTalkColorScheme.onPrimary,
                ),
              ),
              Spacer(),
              Text(
                'Account Details >',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: moneyTalkColorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$1,250.00',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: moneyTalkColorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.trending_up, // or Icons.arrow_outward
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

  Column _activity() {
    return Column(
      children: [
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
            Text(
              'See all',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: moneyTalkColorScheme.primary,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.35,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: moneyTalkColorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
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
                          Icons.shopping_bag_outlined,
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
                        '-\$85.00',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                );
              }
          ),
        )
      ],
    );
  }
}
