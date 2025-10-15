import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salmaproject_new1/core/configs/theme/app_colors.dart';

class CheckoutSuccessPage extends StatelessWidget {
  const CheckoutSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/svg/checkout.png', width: 280),
              const SizedBox(height: 40),
              Text(
                'Order Placed Successfully!',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Thank you for your purchase.\nYour order is being processed.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 16,
                  color: Colors.blueGrey[500],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.adminPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: Text(
                  'Back to Home',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
