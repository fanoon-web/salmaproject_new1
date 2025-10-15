import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/widgets/appbar/app_bar.dart';
import '../../core/configs/theme/app_colors.dart';
import '../home_page/favorite_provider.dart';
import 'empty_favorites.dart';
import 'favorite_item.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favorites = favoriteProvider.favorites;
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BasicAppbar(
          hideBack: true,
          title: Text(
            "Favorite",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        body: favorites.isEmpty
            ? const EmptyFavorites()
            : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final entry = favorites.entries.elementAt(index);
            final productId = entry.key;
            final productValue = entry.value;

            Map productData;
            if (productValue is Map) {
              productData = productValue;
            } else {
              productData = {
                'name': productValue.toString(),
                'image': 'https://via.placeholder.com/150',
                'price': 'N/A',
                'description': '',
              };
            }

            return FavoriteItem(
              productId: productId,
              productData: productData,
              favoriteProvider: favoriteProvider,
            );
          },
        ),
      ),
    );
  }
}
