import 'package:flutter/material.dart';

class MealImage extends StatelessWidget {
  const MealImage({
    required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => Image.network(
        url,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.restaurant),
        ),
      );
}
