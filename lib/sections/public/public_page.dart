import 'package:flutter/material.dart';
import 'package:folio/configs/configs.dart';
import 'package:folio/provider/portfolio_provider.dart';
import 'package:folio/sections/main/main_section.dart';

class PublicPage extends StatefulWidget {
  const PublicPage({Key? key, required this.slug}) : super(key: key);

  final String slug;

  @override
  State<PublicPage> createState() => _PublicPageState();
}

class _PublicPageState extends State<PublicPage> {
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_triggered) {
        _triggered = true;
        PortfolioProvider.state(context, false).loadPublic(widget.slug);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = PortfolioProvider.state(context);
    switch (p.mode) {
      case PortfolioMode.loading:
        return const _PublicLoading();
      case PortfolioMode.public:
      case PortfolioMode.owner:
        return const MainPage();
      case PortfolioMode.error:
        return _PublicError(slug: widget.slug);
    }
  }
}

class _PublicLoading extends StatelessWidget {
  const _PublicLoading();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppTheme.c!.primary),
            const SizedBox(height: 16),
            const Text('Chargement du portfolio…'),
          ],
        ),
      ),
    );
  }
}

class _PublicError extends StatelessWidget {
  const _PublicError({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 72, color: AppTheme.c!.primary),
              const SizedBox(height: 24),
              Text('Portfolio introuvable', style: AppText.h1b),
              const SizedBox(height: 8),
              Text(
                'Aucun portfolio public ne correspond à « $slug ».\n'
                'Vérifiez le lien ou créez le vôtre.',
                textAlign: TextAlign.center,
                style: AppText.l1?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (_) => false),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.c!.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                icon: const Icon(Icons.home_outlined, size: 18),
                label: const Text('Retour à l’accueil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}