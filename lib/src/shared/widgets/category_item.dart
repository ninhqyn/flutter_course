import 'package:flutter/material.dart';
import 'package:learning_app/src/shared/models/category.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 14,
            color: Colors.black.withOpacity(0.07),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Giúp cho Column chỉ cần chiều cao của các phần tử con
        children: [
          Flexible(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
              child: Image.network(
                category.imageUrl == null ? 'assets/images/background_login.png' : category.imageUrl!,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/images/unknown.png',
                    width: double.infinity,
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: Text(
                category.categoryName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
