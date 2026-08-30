import '../models/portfolio_data.dart';

PortfolioData buildDefaultPortfolio() {
  final d = PortfolioData();
  d.name = 'Mohamed';
  d.surname = 'Tounekti';
  d.age = '28';
  d.email = 'tounekti17@gmail.com';
  d.phone = '+12621181239';
  d.location = 'Tunisia';
  d.headline =
      "I'm Mohamed Tounekti, a Flutter & Full-Stack Developer building mobile apps, web platforms and IoT solutions.";
  d.aboutMeDetail =
      "Professional Master's student in Information Systems and Network Development, and Research Master's student in Digital Health Technology Sciences.\n"
      'I develop high-quality Flutter mobile applications backed by Firebase, and I am equally at home building full-stack web apps with React, TypeScript and Node.js. I also work on IoT projects (ESP32, MQTT) and AI-powered tools with Google Gemini.\n'
      'I enjoy turning ideas into polished, reliable and user-friendly products.';
  d.roles = ['Flutter Developer', 'Full-Stack Developer', 'IoT Enthusiast'];
  d.skills = [
    'Flutter',
    'Dart',
    'React',
    'TypeScript',
    'Firebase',
    'Node.js',
    'Kotlin',
    'Python',
    'IoT / MQTT',
  ];
  d.resumeUrl =
      'https://drive.google.com/file/d/1fYgxVVO2SGjvyHD4Xi7irJ9DV7cL4d7k/view?usp=sharing';
  d.services = [
    ServiceItem(
      title: 'Mobile App Development',
      description:
          'Cross-platform apps with Flutter\n- Firebase Auth / Cloud / Messaging\n- REST APIs\n- Maps & notifications\n- Clean, maintainable code',
    ),
    ServiceItem(
      title: 'Full-Stack Web Development',
      description:
          'Modern web platforms\n- React + TypeScript + Vite\n- Node.js / Express backends\n- Recharts dashboards\n- PWA & responsive design',
    ),
    ServiceItem(
      title: 'AI & OCR Solutions',
      description:
          'AI-powered tools\n- Google Gemini & AI Studio\n- OCR document scanning\n- Smart data extraction\n- Chat & automation flows',
    ),
    ServiceItem(
      title: 'IoT & Embedded Systems',
      description:
          'Connected devices\n- ESP32 & sensor projects\n- MQTT brokers\n- Data pipelines & telemetry\n- Python tooling',
    ),
    ServiceItem(
      title: 'UI/UX Designing',
      description:
          'Modern UI/UX Designing\n- Responsive interfaces\n- Mobile & web designs\n- Interactive prototypes\n- From idea to polished product',
    ),
  ];
  d.projects = [
    ProjectItem(
      banner: 'assets/projects/taqyem_banner.png',
      icon: 'assets/projects/taqyem_icon.png',
      title: 'Taqyem',
      description:
          "Complete evaluation & assessment management platform built with Flutter and Firebase: results tracking, offline support and a polished multi-platform mobile experience.",
      link: 'https://github.com/tounektimohamed/taqyem',
    ),
    ProjectItem(
      banner: 'assets/projects/smartcare_banner.png',
      icon: 'assets/projects/smartcare_icon.png',
      title: 'smartCare',
      description:
          'Medication reminder mobile application that helps patients follow their treatment: smart push notifications, secure auth (Firebase), calendar timelines and a clean, accessible UX.',
      link: 'https://github.com/tounektimohamed/smartCare',
    ),
    ProjectItem(
      banner: 'assets/projects/drehatt_banner.png',
      icon: 'assets/projects/drehatt_icon.png',
      title: 'DREHATT',
      description:
          'Geospatial & mapping application powered by Flutter + flutter_map: GeoJSON layers, offline MBTiles, draggable markers and map drawing tools.',
      link: 'https://github.com/tounektimohamed/DREHATT_app',
    ),
    ProjectItem(
      banner: 'assets/projects/joussour_banner.png',
      icon: 'assets/projects/joussour_icon.png',
      title: 'Joussour',
      description:
          "Class & student management app 'Joussour': Cloud Firestore, local notifications and a powerful admin layer with Firebase Cloud Functions.",
      link: 'https://github.com/tounektimohamed/mon-classe',
    ),
    ProjectItem(
      banner: 'assets/projects/avenir_banner.png',
      icon: 'assets/projects/avenir_icon.png',
      title: "Plontant l'Avenir",
      description:
          'Digital platform for scout units: interactive Leaflet maps, drawing tools, QR codes and AI-assisted workflows (Gemini) built with React, TypeScript and Firebase.',
      link: 'https://github.com/tounektimohamed/Plontant-l-avinir-',
    ),
    ProjectItem(
      banner: 'assets/projects/finances_banner.png',
      icon: 'assets/projects/finances_icon.png',
      title: 'Finances Scouts',
      description:
          'Financial dashboard for scout units: real-time stats and charts (Recharts), receipt export to PDF, AI-generated insights (Gemini) and PWA support.',
      link: 'https://github.com/tounektimohamed/Finances-scouts-',
    ),
    ProjectItem(
      banner: 'assets/projects/ocr_banner.png',
      icon: 'assets/projects/ocr_icon.png',
      title: 'Taqyem OCR',
      description:
          'AI-powered OCR application running on Google AI Studio with Gemini for fast document scanning and text extraction.',
      link: 'https://github.com/tounektimohamed/TaqyemOCR',
    ),
    ProjectItem(
      banner: 'assets/projects/camp_banner.png',
      icon: 'assets/projects/camp_icon.png',
      title: 'Camp Connect',
      description:
          'Native Android app (Kotlin) for managing scout camps: scheduling, tasks and reliable offline-friendly workflows.',
      link: 'https://github.com/tounektimohamed/Camp-connect-',
    ),
  ];
  d.education = [
    EducationItem(
      banner: 'assets/projects/images.png',
      icon: 'assets/projects/images.png',
      title: 'Higher Institute of Technological Studies in Tataouine',
      description: 'Information Systems Development',
      link: '',
    ),
    EducationItem(
      banner: 'assets/projects/isets.png',
      icon: 'assets/projects/isets.png',
      title: 'Higher Institute of Technological Studies in Sfax',
      description:
          "Professional Master's in Information Systems and Network Development",
      link: '',
    ),
    EducationItem(
      banner: 'assets/projects/isims.png',
      icon: 'assets/projects/isims.png',
      title: 'Higher Institute of Information and Multimedia in Sfax',
      description: 'Research Master of Science in Digital Technologies for Health Care',
      link: '',
    ),
  ];
  d.contacts = [
    ContactItem(title: 'Location', detail: d.location),
    ContactItem(title: 'Phone', detail: d.phone),
    ContactItem(title: 'Email', detail: d.email),
  ];
  d.socials = [
    SocialItem(name: 'Facebook', url: 'https://facebook.com/tounektimohamed'),
    SocialItem(name: 'Instagram', url: 'https://instagram.com/tounektimohamed'),
    SocialItem(name: 'Twitter', url: 'https://twitter.com/tounektimohamed'),
    SocialItem(name: 'LinkedIn', url: 'https://linkedin.com/in/tounektimohamed'),
    SocialItem(name: 'GitHub', url: 'https://github.com/tounektimohamed'),
    SocialItem(name: 'Medium', url: 'https://tounektimohamed.medium.com'),
  ];
  return d;
}