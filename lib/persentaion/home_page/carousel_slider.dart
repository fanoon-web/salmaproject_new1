import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomerCarouselSlider extends StatelessWidget {
  const CustomerCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final assetImages = [
      'assets/anmation/Carousel1.jpeg',
      'assets/anmation/Carousel2.jpeg',
      'assets/anmation/Carousel3.jpeg',
      'assets/anmation/Carousel4.jpeg',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: assetImages.map((path) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            path,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, __, ___) => Container(
              color: theme.colorScheme.secondary.withOpacity(0.2),
              alignment: Alignment.center,
              child: Icon(
                Icons.broken_image,
                size: 50,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
