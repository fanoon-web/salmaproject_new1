import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salmaproject_new1/persentaion/home_page/productcard.dart';
import '../../core/configs/theme/app_colors.dart';
import '../../common/widgets/appbar/app_bar.dart';
import '../orders/OrdersProvider.dart';
import 'favorite_provider.dart';
import 'filter_chip.dart';
import 'header.dart';
import 'search_field.dart';
import 'categories.dart';
import 'carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final String userEmail;
  const HomePage({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('products').get();
      return snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
    } catch (e) {
      debugPrint("Firestore error: $e");
      return [];
    }
  }

  Widget _getBody() {
    final favProvider = context.watch<FavoriteProvider>();
    final orderProvider = context.read<OrdersProvider>();

    if (_selectedDrawerIndex != 0) return const SizedBox();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return const Center(child: Text("No products yet"));

        final products = snapshot.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(userEmail: widget.userEmail),
              const SizedBox(height: 20),
              const SearchField(),
              const SizedBox(height: 12),
              const CustomFilterChips(),
              const SizedBox(height: 20),
              const CustomerCarouselSlider(),
              const SizedBox(height: 20),
              const Categories(),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) => ProductCard(
                  product: products[index],
                  favProvider: favProvider,
                  orderProvider: orderProvider,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BasicAppbar(
          hideBack: true,
          title: const Text("Computer House"),
        ),
        body: _getBody(),
      ),
    );
  }
}
