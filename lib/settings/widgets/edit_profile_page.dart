import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/assets/app_images.dart';
import '../../core/configs/theme/app_colors.dart';

ImageProvider getProfileImage(String? img) {
  if (img == null || img.isEmpty) return const AssetImage(AppImages.profile);
  if (img.startsWith('http')) return NetworkImage(img);
  try {
    final cleanedBase64 = img.contains(',') ? img.split(',').last : img;
    final bytes = base64Decode(cleanedBase64);
    return MemoryImage(bytes);
  } catch (_) {
    return const AssetImage(AppImages.profile);
  }
}

class EditProfilePage extends StatefulWidget {
  final String userEmail;
  const EditProfilePage({super.key, required this.userEmail});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCon = TextEditingController();
  final _emailCon = TextEditingController();
  final _passwordCon = TextEditingController();

  String? _imageUrl;
  File? _newImage;
  bool _saving = false;
  bool _hidePass = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final response = await Supabase.instance.client
          .from('Users')
          .select()
          .eq('email', widget.userEmail)
          .maybeSingle();

      if (response != null && response is Map) {
        setState(() {
          _nameCon.text = response['name'] ?? '';
          _emailCon.text = response['email'] ?? '';
          _passwordCon.text = response['password'] ?? '';
          _imageUrl = response['image'];
        });
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) setState(() => _newImage = File(file.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      String? imageUrl = _imageUrl;

      if (_newImage != null) {
        final bytes = await _newImage!.readAsBytes();
        imageUrl = base64Encode(bytes); // تخزين الصورة كـ base64
      }

      await Supabase.instance.client
          .from('Users')
          .update({
        'name': _nameCon.text.trim(),
        'email': _emailCon.text.trim(),
        'password': _passwordCon.text,
        'image': imageUrl,
      })
          .eq('email', widget.userEmail);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✅ تم تعديل الملف الشخصي بنجاح'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('فشل تعديل الملف الشخصي: $e'),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
      body: _saving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // صورة البروفايل
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _newImage != null
                      ? FileImage(_newImage!)
                      : getProfileImage(_imageUrl),
                ),
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: AppColors.primary),
                    onPressed: _pickImage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCon,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCon,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordCon,
                    obscureText: _hidePass,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_hidePass ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _hidePass = !_hidePass),
                      ),
                    ),
                    validator: (v) =>
                    (v == null || v.trim().length < 6) ? 'Min 6 characters' : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
