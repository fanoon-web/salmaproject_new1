import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/assets/app_vectors.dart';

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppVectors.cartBag, width: 120, height: 120),
          const SizedBox(height: 20),
          const Text(
            "No Favorite Products Yet",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
