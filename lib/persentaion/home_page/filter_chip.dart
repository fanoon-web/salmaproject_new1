
import 'package:flutter/material.dart';

import '../../core/configs/theme/app_colors.dart';
import '../login_page/_login_page_state.dart';




class CustomFilterChips extends StatelessWidget {
  const CustomFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildCategoryChip(context, Icons.tune, "New", onTap: () {

            }),

            _buildCategoryChip(context, Icons.contact_support," Suppliers",onTap: (){

            }),

            _buildCategoryChip(context, Icons.compare, "Contact"),

            _buildCategoryChip(context,Icons.laptop_chromebook_outlined, "Category",onTap: (){


            }),
          ],
        ),

      );
  }
}


Widget _buildCategoryChip(
    BuildContext context,
    IconData icon,
    String label, {
      VoidCallback? onTap,
    }) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Padding(
    padding: const EdgeInsets.only(right: 8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).primaryColor :  AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.adminPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
