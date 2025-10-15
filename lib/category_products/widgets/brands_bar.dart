import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandsBars extends StatefulWidget {
  final String categoryId;
  final String? selectedBrandId;
  final ValueChanged<String?>? onBrandSelected;

  const BrandsBars({
    super.key,
    required this.categoryId,
    this.selectedBrandId,
    this.onBrandSelected,
  });

  @override
  State<BrandsBars> createState() => _BrandsBarsState();
}

class _BrandsBarsState extends State<BrandsBars> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    // CircleAvatar size responsive
    double avatarRadius = 31;
    double fontSize = 14;

    if (screenWidth > 800) {
      avatarRadius = 45;
      fontSize = 18;
    } else if (screenWidth < 350) {
      avatarRadius = 25;
      fontSize = 12;
    }

    final brandsRef = FirebaseFirestore.instance.collection('Brand');

    return FutureBuilder<QuerySnapshot>(
      future: brandsRef.where('categoryId', isEqualTo: widget.categoryId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final brands = snapshot.data!.docs;
        if (brands.isEmpty) return const SizedBox.shrink();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: brands.map((brand) {
              final data = brand.data() as Map<String, dynamic>;
              final brandId = data['brandId'] ?? '';
              final title = data['title'] ?? 'Brand';
              final logoUrl = data['logoUrl'] ?? '';
              final isSelected = widget.selectedBrandId == brandId;

              return GestureDetector(
                onTap: () {
                  if (widget.onBrandSelected != null) {
                    widget.onBrandSelected!(isSelected ? null : brandId);
                  }
                },
                child: Container(
                 // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: isSelected
                              ? theme.primaryColor
                              : theme.colorScheme.secondary.withOpacity(0.2),
                          backgroundImage:
                          logoUrl.isNotEmpty ? NetworkImage(logoUrl) : null,
                          child: logoUrl.isEmpty
                              ? Text(
                            title.isNotEmpty ? title[0] : '?',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: isSelected
                                  ? Colors.white
                                  : textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w400,
                              fontSize: fontSize,
                            ),
                          )
                              : null,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: avatarRadius * 2,
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: textTheme.displaySmall?.copyWith(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

