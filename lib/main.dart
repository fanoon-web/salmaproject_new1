import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:salmaproject_new1/core/configs/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'OrdersProvider.dart';
import 'core/configs/theme/app_theme.dart';
import 'home_page/home_page.dart';
import 'login_page/_login_page_state.dart';
import 'favorite_provider.dart';
import 'mainshell_page.dart'; // هذا يكفي

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  await Hive.openBox('cart');   // ← أضف هذا
  await Hive.openBox('orders');

  await Supabase.initialize(
    url: 'https://rrmeyggrhasrupvfambu.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJybWV5Z2dyaGFzcnVwdmZhbWJ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU2MjM3MDQsImV4cCI6MjA3MTE5OTcwNH0.co0-a_u3I6jhivQg4SNl-6VPcuZTpINKokBH0d7wIeM',
  );

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // هنا تحدد البريد الإلكتروني للمستخدم
    final String userEmail = 'test@example.com';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: MainShellPage(userEmail: 'test@example.com'), // ← هنا بدل initialRoute
      routes: {
        '/login': (context) => const LoginPage(),
      },
    );

  }

}
