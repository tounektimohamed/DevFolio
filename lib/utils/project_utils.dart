import '../data/active_data.dart';

class ProjectUtils {
  static List<String> get banners =>
      activeData.projects.map((e) => e.banner).toList();

  static List<String> get icons =>
      activeData.projects.map((e) => e.icon).toList();

  static List<String> get titles =>
      activeData.projects.map((e) => e.title).toList();

  static List<String> get description =>
      activeData.projects.map((e) => e.description).toList();

  static List<String> get links =>
      activeData.projects.map((e) => e.link).toList();
}

class Acadimique {
  static List<String> get banners =>
      activeData.education.map((e) => e.banner).toList();

  static List<String> get icons =>
      activeData.education.map((e) => e.icon).toList();

  static List<String> get titles =>
      activeData.education.map((e) => e.title).toList();

  static List<String> get description =>
      activeData.education.map((e) => e.description).toList();

  static List<String> get links =>
      activeData.education.map((e) => e.link).toList();
}