import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:salmaproject_new1/core/configs/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common/helper/navigator/app_navigator.dart';
import '../cart/CartPage.dart';
import '../settings/pages/settings.dart';

class Header extends StatelessWidget {
  final String userEmail;
  const Header({super.key, required this.userEmail});

  Future<Map<String, dynamic>?> getUserData(String email) async {
    try {
      final user = await Supabase.instance.client
          .from('Users')
          .select()
          .eq('email', email)
          .maybeSingle();
      if (user != null && user is Map) {
        return Map<String, dynamic>.from(user);
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<Map<String, dynamic>?>(
      future: getUserData(userEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        final userData = snapshot.data ?? {};
        final userImage = userData['image'] ?? '';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _profileImage(userImage, context),
              _cartIcon(context)

            ],
          ),
        );
      },
    );
  }

  Widget _profileImage(String img, BuildContext context) {
    ImageProvider getImage() {
      if (img.isEmpty) return const AssetImage('assets/images/default_avatar.png');
      if (img.startsWith('http')) return NetworkImage(img);
      try {
        final cleanedBase64 = img.contains(',') ? img.split(',').last : img;
        return MemoryImage(base64Decode(cleanedBase64));
      } catch (_) {
        return const AssetImage('assets/images/default_avatar.png');
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyProfilePage(userEmail: userEmail),
          ),
        );
      },
      child: CircleAvatar(
        radius: 20,
        backgroundImage: getImage(),
      ),
    );
  }

  Widget _cartIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, CartPage());
      },
      child: const Icon(
        Icons.shopping_bag,
        color: AppColors.adminPrimary,
        size: 30,
      ),
    );
  }

}

class ProductOrderedDummy {
  final String name;
  final double price;
  final int quantity;
  final String image;

  ProductOrderedDummy({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });
}
