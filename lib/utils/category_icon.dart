import 'package:flutter/material.dart';

IconData categoryIcon(String categoryId) {
  return switch (categoryId.toLowerCase()) {
    'work' => Icons.work_outline_rounded,
    'personal' => Icons.person_outline_rounded,
    'health' => Icons.favorite_border_rounded,
    'education' => Icons.school_outlined,
    'shopping' => Icons.shopping_bag_outlined,
    'other' => Icons.push_pin_outlined,
    _ => Icons.folder_outlined,
  };
}
