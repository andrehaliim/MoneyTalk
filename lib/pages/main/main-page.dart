import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:money_talk/color_scheme.dart';
import 'package:money_talk/models/category-services.dart';
import 'package:money_talk/pages/home/home-page.dart';
import 'package:money_talk/pages/reports-page.dart';
import 'package:money_talk/pages/settings-page.dart';
import 'package:money_talk/pages/transaction/transaction-page.dart';
import 'package:provider/provider.dart';

import '../../provider/fab-provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final _categoryService = CategoryServices();

  final GlobalKey<HomePageState> _homeKey = GlobalKey<HomePageState>();
  final GlobalKey<TransactionPageState> _transactionKey = GlobalKey<TransactionPageState>();

  final _key = GlobalKey<ExpandableFabState>();

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
      if (index == 0) {
        _homeKey.currentState?.initAllTransaction();
      }

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
            _buildTabNavigator(0, HomePage(key: _homeKey)),
            _buildTabNavigator(1, TransactionPage(key: _transactionKey)),
            _buildTabNavigator(2, const ReportsPage()),
            _buildTabNavigator(3, const SettingsPage()),
          ],
        ),
        floatingActionButton: Consumer<FabProvider>(
          builder: (context, fab, child) {
            if (!fab.visible || _selectedIndex != 1) return const SizedBox.shrink();

            return ExpandableFab(
              key: _key,
              type: ExpandableFabType.up,
              distance: 60,
              childrenAnimation: ExpandableFabAnimation.none,
              openButtonBuilder: DefaultFloatingActionButtonBuilder(
                child: Icon(Icons.add, color: moneyTalkColorScheme.surface,),
                fabSize: ExpandableFabSize.small,
                backgroundColor: moneyTalkColorScheme.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                child: Icon(Icons.close, color: moneyTalkColorScheme.surface,),
                fabSize: ExpandableFabSize.small,
                backgroundColor: moneyTalkColorScheme.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              children: [
                Material(
                  color: moneyTalkColorScheme.tertiary,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 3,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      _key.currentState?.close();
                      context.read<FabProvider>().hide();
                      _transactionKey.currentState?.showGenerate();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                        child: Row(
                        children: [
                          Text(
                              'AI Generate',
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: moneyTalkColorScheme.surface)
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.auto_awesome,
                            color: moneyTalkColorScheme.surface,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Material(
                  color: moneyTalkColorScheme.tertiary,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 3,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      _key.currentState?.close();
                      context.read<FabProvider>().hide();
                      _transactionKey.currentState?.showAdd();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Text(
                              'Manual Entry',
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: moneyTalkColorScheme.surface)
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.edit,
                            color: moneyTalkColorScheme.surface,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        floatingActionButtonLocation: ExpandableFab.location,
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
