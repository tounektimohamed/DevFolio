import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:folio/firebase_options.dart';
import 'package:folio/provider/app_provider.dart';
import 'package:folio/provider/drawer_provider.dart';
import 'package:folio/provider/portfolio_provider.dart';
import 'package:folio/provider/scroll_provider.dart';
import 'package:folio/sections/admin/editor_screen.dart';
import 'package:folio/sections/main/main_section.dart';
import 'package:folio/sections/public/public_page.dart';
import 'package:folio/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:folio/configs/app.dart';
import 'package:folio/configs/core_theme.dart' as theme;
import 'package:folio/configs/configs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => DrawerProvider()),
        ChangeNotifierProvider(create: (_) => ScrollProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider.ensureInstance()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, value, _) => MaterialChild(
          provider: value,
        ),
      ),
    );
  }
}

class MaterialChild extends StatefulWidget {
  final AppProvider provider;
  const MaterialChild({Key? key, required this.provider}) : super(key: key);

  @override
  State<MaterialChild> createState() => _MaterialChildState();
}

class _MaterialChildState extends State<MaterialChild> {
  void initAppTheme() {
    final appProviders = AppProvider.state(context);
    appProviders.init();
  }

  @override
  void initState() {
    initAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portfolio',
      theme: theme.themeLight,
      darkTheme: theme.themeDark,
      themeMode: widget.provider.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeGate(),
      },
      onGenerateRoute: (settings) {
        final name = settings.name;
        if (name == '/admin') {
          return MaterialPageRoute(
            builder: (_) => const EditorScreen(),
          );
        }
        if (name != null && name.startsWith('/p/')) {
          final slug = name.substring('/p/'.length);
          if (slug.isNotEmpty) {
            return MaterialPageRoute(
              builder: (_) => PublicPage(slug: slug),
            );
          }
        }
        return null;
      },
    );
  }
}

class HomeGate extends StatefulWidget {
  const HomeGate({Key? key}) : super(key: key);

  @override
  State<HomeGate> createState() => _HomeGateState();
}

class _HomeGateState extends State<HomeGate> {
  bool _booted = false;
  StreamSubscription<User?>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = AuthService.instance.userStream.listen((user) {
      _booted = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _bootstrap(user?.uid);
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap(null));
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _bootstrap(String? uid) {
    if (_booted) return;
    _booted = true;
    PortfolioProvider.state(context, false)
        .bootstrap(uid: uid ?? AuthService.instance.currentUser?.uid);
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Consumer<PortfolioProvider>(
      builder: (context, p, _) {
        if (p.mode == PortfolioMode.loading) {
          return const _Splash();
        }
        return Stack(
          children: [
            const MainPage(),
            if (p.isOwnerMode)
              Positioned(
                right: 22,
                bottom: 24,
                child: FloatingActionButton.small(
                  heroTag: 'adminFab',
                  backgroundColor: AppTheme.c!.primary,
                  foregroundColor: Colors.white,
                  tooltip: 'Éditer mon portfolio',
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/admin'),
                  child: const Icon(Icons.edit, size: 18),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.c!.scaffold,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppTheme.c!.primary),
            const SizedBox(height: 20),
            Text('Portfolio', style: AppText.h1b),
          ],
        ),
      ),
    );
  }
}