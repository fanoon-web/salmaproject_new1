import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/configs/theme/app_custom_bottom_nav_bar.dart';
import '../cart/CartPage.dart';
import '../favorite/favorites_page.dart';
import '../orders/OrdersPage.dart';
import '../settings/pages/settings.dart';
import 'favorite_provider.dart';
import 'home_page.dart';


class MainShellPage extends StatefulWidget {
  final String userEmail;
  const MainShellPage({super.key, required this.userEmail});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(userEmail: widget.userEmail),
      OrdersPage(),
      CartPage(),
      FavoritesPage(),
      MyProfilePage(userEmail: '',),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
