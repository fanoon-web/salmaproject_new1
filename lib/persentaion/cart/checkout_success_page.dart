import 'package:flutter/material.dart';
import 'package:salmaproject_new1/core/configs/theme/app_colors.dart';

import '../../common/widgets/button/basic_app_button.dart';
import '../../common/widgets/text/basic_app_text.dart';

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
            spacing: 25,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/svg/checkout.png', width: 280),

              BasicAppText(
                title: 'Order Placed Successfully!',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 24),
              ),

              BasicAppText(
                title:
                    'Thank you for your purchase.\nYour order is being processed.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: Colors.blueGrey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),

              BasicAppButton(
                onPressed: () => Navigator.pop(context),
                title: 'Back to Home',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
