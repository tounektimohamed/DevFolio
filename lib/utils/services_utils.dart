import 'package:flutter/material.dart';

import '../data/active_data.dart';
import 'utils.dart';

class ServicesUtils {
  static const List<String> servicesIcons = [
    StaticUtils.appDev,
    StaticUtils.rapid,
    StaticUtils.blog,
    StaticUtils.openSource,
    StaticUtils.uiux,
  ];

  static List<String> get servicesTitles =>
      activeData.services.map((e) => e.title).toList();

  static List<String> get servicesDescription =>
      activeData.services.map((e) => e.description).toList();
}