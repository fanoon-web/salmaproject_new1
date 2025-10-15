import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CartPage.dart';
import 'OrdersPage.dart';
import 'core/configs/theme/app_custom_bottom_nav_bar.dart';
import 'favorite_provider.dart';
import 'home_page/home_page.dart';


class MainShellPage extends StatefulWidget {
  final String userEmail;
  const MainShellPage({super.key, required this.userEmail});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _selectedIndex = 0;

  // الصفحات التي ستتغير حسب التبويب
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(userEmail: widget.userEmail),
      OrdersPage(),    // صفحة الطلبات
     // SearchPage(),       // صفحة البحث
  CartPage(),
      FavoritesPage(),

      CartPage(),  // صفحة المفضلة
     // ProfilePage(),      // صفحة الحساب
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
