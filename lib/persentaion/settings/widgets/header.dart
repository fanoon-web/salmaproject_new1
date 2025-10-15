import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/assets/app_images.dart';

class UserEntity {
  final String id;
  final String name;
  final String email;
  final String image;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });
}

class HeaderSetting extends StatelessWidget {
  final String userEmail;
  const HeaderSetting({super.key, required this.userEmail});

  // دالة لجلب بيانات المستخدم من Supabase
  Future<UserEntity?> getUserData(String email) async {
    try {
      final user = await Supabase.instance.client
          .from('Users') // تأكد أن اسم الجدول صحيح
          .select()
          .eq('email', email)
          .maybeSingle();

      if (user != null && user is Map) {
        return UserEntity(
          id: user['id'] ?? '',
          name: user['name'] ?? '',
          email: user['email'] ?? '',
          image: user['image'] ?? '',
        );
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserEntity?>(
      future: getUserData(userEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;

        if (user == null) {
          return const Center(child: Text('User not found'));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              _profileImage(user),
              const SizedBox(height: 12),
              Text(
                user.name.isNotEmpty ? user.name : 'No Name',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _profileImage(UserEntity user) {
    ImageProvider getImage() {
      if (user.image.isEmpty) {
        return const AssetImage(AppImages.profile);
      } else if (user.image.startsWith('http')) {
        return NetworkImage(user.image);
      } else {
        try {
          final cleanedBase64 =
          user.image.contains(',') ? user.image.split(',').last : user.image;
          final bytes = base64Decode(cleanedBase64);
          return MemoryImage(bytes);
        } catch (_) {
          return const AssetImage(AppImages.profile);
        }
      }
    }

    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: getImage(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
