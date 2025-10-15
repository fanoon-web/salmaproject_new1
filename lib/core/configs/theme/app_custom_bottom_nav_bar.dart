import 'package:flutter/material.dart';
import 'package:salmaproject_new1/core/configs/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final List<IconData> _icons = [
    Icons.home,
    Icons.shopping_bag,
    Icons.search_sharp,
    Icons.favorite,

    Icons.person,
  ];

  final List<String> _labels = [
    "Home",
    "Orders",
    "Search",
    "Favorites",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:  Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            bool isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => onItemTapped(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: isSelected
                        ? BoxDecoration(
                      color: AppColors.adminthird.withOpacity(0.2),
                      shape: BoxShape.circle,
                    )
                        : null,
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      _icons[index],
                      color: isSelected ? AppColors.adminPrimary : Colors.grey,
                      size: isSelected ? 32 : 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _labels[index],
                    style: TextStyle(
                      color: isSelected ? AppColors.adminPrimary : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );

  }
}
