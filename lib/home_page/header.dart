import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salmaproject_new1/core/configs/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../home_page/home_page.dart';

import '../CartPage.dart';
import '../common/helper/navigator/app_navigator.dart';
import '../core/assets/app_vectors.dart';
import '../settings/pages/settings.dart';
// تأكد من المسار الصحيح لصفحة الملف الشخصي

class Header extends StatelessWidget {
  final String userEmail;
  const Header({super.key, required this.userEmail});

  // دالة لجلب بيانات المستخدم من Supabase
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

        // استخدام القيمة الافتراضية إذا لم توجد بيانات
        final userData = snapshot.data ?? {};
        final userImage = userData['image'] ?? '';

        return Padding(
          padding: const EdgeInsets.only(top: 5, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _profileImage(userImage, context),
              _cartIcon(context),
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
        final bytes = base64Decode(cleanedBase64);
        return MemoryImage(bytes);
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
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: getImage(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _cartIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context,  CartPage());
      },
      child: const Icon(
        Icons.shopping_bag,
        color: AppColors.adminPrimary,
        size: 30,
      ),
    );
  }
}



// نموذج بيانات وهمي
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


