class ContactItem {
  String title;
  String detail;
  ContactItem({required this.title, required this.detail});

  ContactItem copy() => ContactItem(title: title, detail: detail);

  factory ContactItem.fromMap(Map<String, dynamic> m) => ContactItem(
        title: (m['title'] ?? '') as String,
        detail: (m['detail'] ?? '') as String,
      );

  Map<String, dynamic> toMap() => {'title': title, 'detail': detail};
}

class ServiceItem {
  String title;
  String description;
  ServiceItem({required this.title, required this.description});

  ServiceItem copy() => ServiceItem(title: title, description: description);

  factory ServiceItem.fromMap(Map<String, dynamic> m) => ServiceItem(
        title: (m['title'] ?? '') as String,
        description: (m['description'] ?? '') as String,
      );

  Map<String, dynamic> toMap() => {'title': title, 'description': description};
}

class ProjectItem {
  String banner;
  String icon;
  String title;
  String description;
  String link;
  ProjectItem({
    required this.banner,
    required this.icon,
    required this.title,
    required this.description,
    required this.link,
  });

  ProjectItem copy() => ProjectItem(
        banner: banner,
        icon: icon,
        title: title,
        description: description,
        link: link,
      );

  factory ProjectItem.fromMap(Map<String, dynamic> m) => ProjectItem(
        banner: (m['banner'] ?? '') as String,
        icon: (m['icon'] ?? '') as String,
        title: (m['title'] ?? '') as String,
        description: (m['description'] ?? '') as String,
        link: (m['link'] ?? '') as String,
      );

  Map<String, dynamic> toMap() => {
        'banner': banner,
        'icon': icon,
        'title': title,
        'description': description,
        'link': link,
      };
}

class EducationItem {
  String banner;
  String icon;
  String title;
  String description;
  String link;
  EducationItem({
    required this.banner,
    required this.icon,
    required this.title,
    required this.description,
    required this.link,
  });

  EducationItem copy() => EducationItem(
        banner: banner,
        icon: icon,
        title: title,
        description: description,
        link: link,
      );

  factory EducationItem.fromMap(Map<String, dynamic> m) => EducationItem(
        banner: (m['banner'] ?? '') as String,
        icon: (m['icon'] ?? '') as String,
        title: (m['title'] ?? '') as String,
        description: (m['description'] ?? '') as String,
        link: (m['link'] ?? '') as String,
      );

  Map<String, dynamic> toMap() => {
        'banner': banner,
        'icon': icon,
        'title': title,
        'description': description,
        'link': link,
      };
}

class ExperienceItem {
  String position;
  String company;
  String duration;
  String description;
  ExperienceItem({
    required this.position,
    required this.company,
    required this.duration,
    required this.description,
  });

  ExperienceItem copy() => ExperienceItem(
        position: position,
        company: company,
        duration: duration,
        description: description,
      );

  factory ExperienceItem.fromMap(Map<String, dynamic> m) => ExperienceItem(
        position: (m['position'] ?? '') as String,
        company: (m['company'] ?? '') as String,
        duration: (m['duration'] ?? '') as String,
        description: (m['description'] ?? '') as String,
      );

  Map<String, dynamic> toMap() => {
        'position': position,
        'company': company,
        'duration': duration,
        'description': description,
      };
}

class SocialItem {
  String name;
  String url;
  SocialItem({required this.name, required this.url});

  SocialItem copy() => SocialItem(name: name, url: url);

  factory SocialItem.fromMap(Map<String, dynamic> m) => SocialItem(
        name: (m['name'] ?? '') as String,
        url: (m['url'] ?? '') as String,
      );

  Map<String, dynamic> toMap() => {'name': name, 'url': url};
}

class PortfolioData {
  PortfolioData();

  String name = 'Mohamed';
  String surname = 'Tounekti';
  String age = '28';
  String email = 'tounekti17@gmail.com';
  String phone = '+12621181239';
  String location = 'Tunisia';
  String headline = '';
  String aboutMeDetail = '';
  String avatar = 'assets/photos/colored.png';
  String photoColored = 'assets/photos/colored.png';
  String photoBlackWhite = 'assets/photos/black-white.png';
  String photoMobile = 'assets/photos/mobile.png';
  String resumeUrl = '';
  String githubUrl = 'https://github.com/tounektimohamed';
  String slug = 'mohamed';
  List<String> roles = [];
  List<String> skills = [];
  List<ServiceItem> services = [];
  List<ProjectItem> projects = [];
  List<EducationItem> education = [];
  List<ExperienceItem> experiences = [];
  List<ContactItem> contacts = [];
  List<SocialItem> socials = [];

  Map<String, dynamic> toMap() => {
        'name': name,
        'surname': surname,
        'age': age,
        'email': email,
        'phone': phone,
        'location': location,
        'headline': headline,
        'aboutMeDetail': aboutMeDetail,
        'avatar': avatar,
        'photoColored': photoColored,
        'photoBlackWhite': photoBlackWhite,
        'photoMobile': photoMobile,
        'resumeUrl': resumeUrl,
        'githubUrl': githubUrl,
        'slug': slug,
        'roles': roles,
        'skills': skills,
        'services': services.map((e) => e.toMap()).toList(),
        'projects': projects.map((e) => e.toMap()).toList(),
        'education': education.map((e) => e.toMap()).toList(),
        'experiences': experiences.map((e) => e.toMap()).toList(),
        'contacts': contacts.map((e) => e.toMap()).toList(),
        'socials': socials.map((e) => e.toMap()).toList(),
      };

  factory PortfolioData.fromMap(Map<String, dynamic> m) {
    final d = PortfolioData();
    d.name = (m['name'] ?? '') as String;
    d.surname = (m['surname'] ?? '') as String;
    d.age = (m['age'] ?? '') as String;
    d.email = (m['email'] ?? '') as String;
    d.phone = (m['phone'] ?? '') as String;
    d.location = (m['location'] ?? '') as String;
    d.headline = (m['headline'] ?? '') as String;
    d.aboutMeDetail = (m['aboutMeDetail'] ?? '') as String;
    d.avatar = (m['avatar'] ?? '') as String;
    d.photoColored = (m['photoColored'] ?? '') as String;
    d.photoBlackWhite = (m['photoBlackWhite'] ?? '') as String;
    d.photoMobile = (m['photoMobile'] ?? '') as String;
    d.resumeUrl = (m['resumeUrl'] ?? '') as String;
    d.githubUrl = (m['githubUrl'] ?? '') as String;
    d.slug = (m['slug'] ?? '') as String;
    d.roles = ((m['roles'] ?? []) as List).cast<String>();
    d.skills = ((m['skills'] ?? []) as List).cast<String>();
    d.services = ((m['services'] ?? []) as List)
        .map((e) => ServiceItem.fromMap(e as Map<String, dynamic>))
        .toList();
    d.projects = ((m['projects'] ?? []) as List)
        .map((e) => ProjectItem.fromMap(e as Map<String, dynamic>))
        .toList();
    d.education = ((m['education'] ?? []) as List)
        .map((e) => EducationItem.fromMap(e as Map<String, dynamic>))
        .toList();
    d.experiences = ((m['experiences'] ?? []) as List)
        .map((e) => ExperienceItem.fromMap(e as Map<String, dynamic>))
        .toList();
    d.contacts = ((m['contacts'] ?? []) as List)
        .map((e) => ContactItem.fromMap(e as Map<String, dynamic>))
        .toList();
    d.socials = ((m['socials'] ?? []) as List)
        .map((e) => SocialItem.fromMap(e as Map<String, dynamic>))
        .toList();
    return d;
  }

  PortfolioData copy() => PortfolioData.fromMap(toMap());
}