import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_talk/transaction-detail-page.dart';
import 'package:money_talk/widgets.dart';

import 'color_scheme.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool _isIncome = true;
  bool _isAdding = false;
  final List<String> _categoryList = ["Bills & Utilities", 'Clothing', 'Education', 'Entertainment'];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedCategory;

  void changeType() {
    setState(() {
      _isIncome = !_isIncome;
    });
  }

  void showAdd() {
    setState(() {
      _isAdding = !_isAdding;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Transactions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _typeSwitcher(),
                SizedBox(height: 20),
                _isAdding ? _addTransaction() : Expanded(child: _transaction()),
              ],
            ),
          ),
          Visibility(
            visible: !_isAdding,
            child: Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: showAdd,
                backgroundColor: moneyTalkColorScheme.tertiary,
                child: Icon(Icons.add, color: moneyTalkColorScheme.onPrimary, size: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _typeSwitcher() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: changeType,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: _isIncome ? moneyTalkColorScheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(child: Text('Income', style: Theme.of(context).textTheme.bodyMedium)),
              ),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: GestureDetector(
              onTap: changeType,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: !_isIncome ? moneyTalkColorScheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(child: Text('Expenses', style: Theme.of(context).textTheme.bodyMedium)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _transaction() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _isIncome ? 'Total Income' : 'Total Expenses',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TranactionDetailPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: moneyTalkColorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.shopping_bag_outlined, color: moneyTalkColorScheme.primary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Groceries',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: moneyTalkColorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '-\$85.00',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(color: moneyTalkColorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _addTransaction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: moneyTalkColorScheme.onSurface),
        ),
        SizedBox(height: 10),
        DefaultWidgets().defaultTextfield(context, _dateController, Icons.calendar_today, () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
          }
        }),
        SizedBox(height: 20),

        Text(
          'Amount',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: moneyTalkColorScheme.onSurface),
        ),
        SizedBox(height: 10),
        DefaultWidgets().defaultTextfield(context, _amountController, Icons.attach_money, null),
        SizedBox(height: 20),

        Text(
          'Category',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: moneyTalkColorScheme.onSurface),
        ),
        SizedBox(height: 10),
        DropdownSearch<String>(
          selectedItem: _selectedCategory,
          items: (f, cs) => _categoryList,
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
          popupProps: PopupProps.menu(
            itemBuilder: (context, item, isDisabled, isSelected) {
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: moneyTalkColorScheme.onSurface),
                ),
              );
            },
            fit: FlexFit.loose,
            menuProps: MenuProps(
              backgroundColor: moneyTalkColorScheme.surface,
              elevation: 1,
              margin: EdgeInsets.only(top: 12),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          decoratorProps: DropDownDecoratorProps(
            baseStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: moneyTalkColorScheme.onSurface),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withAlpha(50), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: moneyTalkColorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withAlpha(50), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),

        Text(
          'Note',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: moneyTalkColorScheme.onSurface),
        ),
        SizedBox(height: 10),
        DefaultWidgets().defaultTextfield(context, _noteController, Icons.note_add_outlined, null),
        SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: showAdd,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Colors.grey.withAlpha(50), width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                child: Text(
                  "Cancel",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: moneyTalkColorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  side: BorderSide(color: moneyTalkColorScheme.primary, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                child: Text(
                  "Save",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: moneyTalkColorScheme.surface, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
