import 'package:flutter/material.dart';

class CategorysSection extends StatelessWidget {
  const CategorysSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      "Work",
      "Study",
      "Personal",
      "Gym",
      "Shopping",
      "Travel",
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: categories.map((cat) {
          return ListTile(
            title: Text(
              cat,
              style: const TextStyle(
                color: Color(0xFFB2DFDB),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.pop(context, cat);
            },
          );
        }).toList(),
      ),
    );
  }
}