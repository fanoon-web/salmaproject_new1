import 'package:flutter/material.dart';

class ProductsSearchBar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onFilterTap;

  const ProductsSearchBar({
    super.key,
    this.searchQuery = '',
    required this.onSearchChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizes
    double searchFontSize = 14;
    double iconSize = 28;
    double horizontalPadding = 16;
    double verticalPadding = 4;

    if (screenWidth > 800) {
      searchFontSize = 18;
      iconSize = 34;
      horizontalPadding = 24;
      verticalPadding = 8;
    } else if (screenWidth < 350) {
      searchFontSize = 12;
      iconSize = 24;
      horizontalPadding = 8;
      verticalPadding = 2;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                hintStyle: textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey, fontSize: searchFontSize),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                filled: true,
                fillColor: theme.disabledColor.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: onSearchChanged,
              style: textTheme.bodyMedium?.copyWith(fontSize: searchFontSize),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(12),
            child: Icon(
              Icons.tune,
              color: theme.primaryColor,
              size: iconSize,
            ),
          ),
        ],
      ),
    );
  }
}
