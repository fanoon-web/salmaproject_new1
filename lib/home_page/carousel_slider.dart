
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
class CustomerCarouselSlider extends StatelessWidget {
  const CustomerCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> assetImages = const [
      'assets/anmation/Carousel1.jpeg',
      'assets/anmation/Carousel2.jpeg',
      'assets/anmation/Carousel3.jpeg',
      'assets/anmation/Carousel4.jpeg',
    ];

    return  CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: assetImages.map((path) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                path,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  );
                },
              ),
            );
          },
        );
      }).toList(),
    );
  }
}






