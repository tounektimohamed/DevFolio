import 'package:folio/utils/utils.dart';

class ServicesUtils {
  static const List<String> servicesIcons = [
    StaticUtils.appDev,
    StaticUtils.rapid,
    StaticUtils.blog,
    StaticUtils.openSource,
    StaticUtils.uiux,
  ];

  static const List<String> servicesTitles = [
    "Mobile App Development",
    "Full-Stack Web Development",
    "AI & OCR Solutions",
    "IoT & Embedded Systems",
    "UI/UX Designing",
  ];

  static const List<String> servicesDescription = [
    "Cross-platform apps with Flutter\n- Firebase Auth / Cloud / Messaging\n- REST APIs\n- Maps & notifications\n- Clean, maintainable code",
    "Modern web platforms\n- React + TypeScript + Vite\n- Node.js / Express backends\n- Recharts dashboards\n- PWA & responsive design",
    "AI-powered tools\n- Google Gemini & AI Studio\n- OCR document scanning\n- Smart data extraction\n- Chat & automation flows",
    "Connected devices\n- ESP32 & sensor projects\n- MQTT brokers\n- Data pipelines & telemetry\n- Python tooling",
    "Modern UI/UX Designing\n- Responsive interfaces\n- Mobile & web designs\n- Interactive prototypes\n- From idea to polished product",
  ];
}
