import 'package:flutter/material.dart';

import '../data/active_data.dart';

class ContactUtils {
  static const List<IconData> contactIcon = [
    Icons.home,
    Icons.phone,
    Icons.mail,
  ];

  static const List<String> titles = [
    "Location",
    "Phone",
    "Email",
  ];

  static List<String> get details =>
      activeData.contacts.map((e) => e.detail).toList();
}