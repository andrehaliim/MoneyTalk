import 'package:flutter/material.dart';
import 'package:money_talk/pages/home/home-page.dart';
import 'package:money_talk/models/category-services.dart';
import 'package:money_talk/pages/reports-page.dart';
import 'package:money_talk/pages/settings-page.dart';
import 'package:money_talk/pages/transaction/transaction-page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final _categoryService = CategoryServices();

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _navigatorKeys[index]
          .currentState
          ?.popUntil((route) => route.isFirst);

      setState(() {
        _selectedIndex = index;
      });
    }
  }
  @override
  void initState() {
    initCategory();
    super.initState();
  }

  void initCategory() async {
    await _categoryService.initDefaultCategories();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final NavigatorState currentNavigator =
        _navigatorKeys[_selectedIndex].currentState!;

        if (currentNavigator.canPop()) {
          currentNavigator.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildTabNavigator(0, const HomePage()),
            _buildTabNavigator(1, const TransactionPage()),
            _buildTabNavigator(2, const ReportsPage()),
            _buildTabNavigator(3, const SettingsPage()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Transaction',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabNavigator(int index, Widget rootPage) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => rootPage,
        );
      },
    );
  }
}
