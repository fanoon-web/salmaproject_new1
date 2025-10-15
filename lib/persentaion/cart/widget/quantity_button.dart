import 'package:flutter/material.dart';
import '../../../core/configs/theme/app_colors.dart';

class QuantityButton extends StatelessWidget {
  final String symbol; // مثل + أو -
  final String productId;
  final VoidCallback onPressed;

  const QuantityButton({
    Key? key,
    required this.symbol,
    required this.productId,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.thirdBackground,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          symbol,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
