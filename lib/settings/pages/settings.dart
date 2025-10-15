import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../OrdersPage.dart';
import '../../OrdersProvider.dart';
import '../../common/widgets/appbar/app_bar.dart';
import '../../core/assets/app_vectors.dart';
import '../../core/configs/theme/app_colors.dart';
import '../widgets/edit_profile_page.dart';


ImageProvider getProfileImage(String? img) {
  if (img == null || img.isEmpty) return const AssetImage('assets/images/default_avatar.png');
  if (img.startsWith('http')) return NetworkImage(img);
  try {
    final cleanedBase64 = img.contains(',') ? img.split(',').last : img;
    final bytes = base64Decode(cleanedBase64);
    return MemoryImage(bytes);
  } catch (_) {
    return const AssetImage('assets/images/default_avatar.png');
  }
}

class MyProfilePage extends StatefulWidget {
  final String userEmail;
  const MyProfilePage({super.key, required this.userEmail});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool _loading = true;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _loading = true);
    try {
      final response = await Supabase.instance.client
          .from('Users')
          .select()
          .eq('email', widget.userEmail)
          .maybeSingle();

      if (response != null && response is Map<String, dynamic>) {
        _user = response;
      } else {
        _user = null;
      }
    } catch (e) {
      _user = null;
      debugPrint('Error fetching user: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = AppColors.primary;

    return Scaffold(
      appBar: BasicAppbar(title: const Text('My Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? Center(
        child: Text(
          'No user data found',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // البطاقة العلوية
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    color: Colors.black.withOpacity(.05),
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: getProfileImage(_user!['image']),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_user!['firstName'] ?? ''} ${_user!['lastName'] ?? ''}'.trim(),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _user!['email'] ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: primaryColor.withOpacity(0.85),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProfilePage(
                                    userEmail: widget.userEmail,
                                  ),
                                ),
                              );
                              await _loadUser(); // إعادة تحميل البيانات بعد التعديل
                            },
                            child: Text(
                              'Edit Profile',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // القائمة
            _ProfileTile(
              icon: Icons.shopping_bag_outlined,
              title: 'Orders',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrdersPage(), // صفحة الطلبات الحقيقية
                  ),
                );
              },
              theme: theme,
            ),

            _ProfileTile(
              icon: Icons.location_on_outlined,
              title: 'Location',
              onTap: () {},
              theme: theme,
            ),
            _ProfileTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Theme',
              theme: theme,
            ),
            _ProfileTile(
              icon: Icons.logout,
              title: 'Log out',
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out'), duration: Duration(seconds: 2)),
                  );
                }
              },
              theme: theme,
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.theme,
    this.isLogout = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final ThemeData? theme;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    final color = isLogout
        ? AppColors.primary
        : (theme?.brightness == Brightness.dark ? Colors.white : Colors.black);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme?.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            color: Colors.black.withOpacity(.04),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: theme?.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: color,
          ),
        ),
        trailing: trailing ?? Icon(Icons.chevron_right, color: color),
        onTap: onTap,
      ),
    );
  }
}
