import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_talk/models/category-model.dart';
import 'package:money_talk/models/category-services.dart';
import 'package:money_talk/models/transaction-model.dart';
import 'package:money_talk/models/transaction-services.dart';
import 'package:money_talk/pages/formatting.dart';
import 'package:money_talk/pages/transaction/transaction-detail-page.dart';
import 'package:money_talk/widgets.dart';
import 'package:provider/provider.dart';

import '../../color_scheme.dart';
import '../../provider/fab-provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => TransactionPageState();
}

class TransactionPageState extends State<TransactionPage> {
  final _categoryService = CategoryServices();
  final _transactionService = TransactionServices();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final List<CategoryModel> _categoryList = [];
  final Map<int, double> _categoryTotals = {};
  CategoryModel? _selectedCategory;

  bool _isIncome = true;
  bool _isLoading = false;
  int _selectedIndex = 0;

  void changeType() {
    setState(() {
      _isIncome = !_isIncome;
      initCategory();
      _selectedCategory = null;
    });
  }

  void showAdd() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void showGenerate() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  void showMain() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  void initState() {
    initCategory();
    super.initState();
  }

  void initCategory() async {
    setState(() {
      _isLoading = true;
    });

    _categoryList.clear();
    _categoryTotals.clear();

    List<CategoryModel> categories;
    if (_isIncome) {
      categories = await _categoryService.getAllCategoryIncome();
    } else {
      categories = await _categoryService.getAllCategoryExpense();
    }

    for (var category in categories) {
      double total = await _transactionService.getTotalTransaction(category.id, _isIncome);
      _categoryTotals[category.id] = total;
    }

    setState(() {
      _categoryList.addAll(categories);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: !_isLoading ? Padding(
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
            _selectedIndex == 0 ? Expanded(child: _transaction()) : const SizedBox.shrink(),
            _selectedIndex == 1 ? Expanded(child: _addTransaction()) : const SizedBox.shrink(),
            _selectedIndex == 2 ? Expanded(child: _generateAI()) : const SizedBox.shrink(),
          ],
        ),
      ) : Center(child: CircularProgressIndicator(),),
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
            itemCount: _categoryList.length,
            itemBuilder: (context, index) {
              final data = _categoryList[index];
              final double totalTransaction = _categoryTotals[data.id] ?? 0.0;

              return GestureDetector(
                onTap: () async {
                  List<TransactionModel> list = await _transactionService.getCategoryTransactions(data.id, _isIncome);
                  context.read<FabProvider>().hide();

                  bool refresh = await
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TransactionDetailPage(category: data,transactions: list)));

                  if(refresh) {
                    initCategory();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: data.isIncome ? moneyTalkColorScheme.primaryContainer : moneyTalkColorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(data.icon, color: data.isIncome ? moneyTalkColorScheme.primary : moneyTalkColorScheme.error),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: moneyTalkColorScheme.onSurface,
                              ),
                            ),
                            Text(
                              'Rp. ${Formatting().formatRupiah(totalTransaction)}',
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
        }, null),
        SizedBox(height: 20),

        Text(
          'Amount',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: moneyTalkColorScheme.onSurface),
        ),
        SizedBox(height: 10),
        DefaultWidgets().defaultTextfield(context, _amountController, null, null, Text('Rp.', style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey))),
        SizedBox(height: 20),

        Text(
          'Category',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: moneyTalkColorScheme.onSurface),
        ),
        SizedBox(height: 10),
        DropdownSearch<CategoryModel>(
          selectedItem: _selectedCategory,
          items: (f, cs) => _categoryList,
          compareFn: (item1, item2) => item1.id == item2.id,
          itemAsString: (CategoryModel u) => u.name,
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
          popupProps: PopupProps.menu(
            itemBuilder: (context, item, isDisabled, isSelected) {
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Icon(item.icon, color: item.isIncome ? moneyTalkColorScheme.primary : moneyTalkColorScheme.error),
                    const SizedBox(width: 12),
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: moneyTalkColorScheme.onSurface),
                    ),
                  ],
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
        DefaultWidgets().defaultTextfield(context, _noteController, Icons.note_add_outlined, null, null),
        SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  context.read<FabProvider>().show();
                  showMain();
                },
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
                onPressed: () async {
                  TransactionModel data = TransactionModel(
                      amount: double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0,
                      categoryName: _selectedCategory?.name ?? '',
                      categoryId: _selectedCategory?.id ?? 0,
                      note: _noteController.text,
                      date: DateTime.now(),
                      isIncome: _isIncome
                  );
                  await _transactionService.insertTransaction(data);
                  initCategory();
                  resetAll();
                  context.read<FabProvider>().show();
                  showMain();
                },
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

  Widget _generateAI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Write your ${_isIncome ? 'Income' : 'Expense'} here and we will help you to generate your transaction.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: moneyTalkColorScheme.onSurface),
        ),
        SizedBox(height: 10),
        Expanded(
          child: TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            expands: true,
            maxLines: null,
            minLines: null,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.withAlpha(50), width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.withAlpha(50), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.withAlpha(50), width: 2),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  context.read<FabProvider>().show();
                  showMain();
                },
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
                onPressed: () async {
                  TransactionModel data = TransactionModel(
                      amount: double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0,
                      categoryName: _selectedCategory?.name ?? '',
                      categoryId: _selectedCategory?.id ?? 0,
                      note: _noteController.text,
                      date: DateTime.now(),
                      isIncome: _isIncome
                  );
                  await _transactionService.insertTransaction(data);
                  initCategory();
                  resetAll();
                  context.read<FabProvider>().show();
                  showMain();
                },
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
        SizedBox(height: 10),
      ]
    );
  }

  void resetAll() {
    setState(() {
      _dateController.clear();
      _amountController.clear();
      _selectedCategory = null;
      _noteController.clear();
    });
  }
}
