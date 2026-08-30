import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folio/configs/configs.dart';
import 'package:folio/data/active_data.dart';
import 'package:folio/models/portfolio_data.dart';
import 'package:folio/provider/portfolio_provider.dart';
import 'package:folio/sections/admin/form_fields.dart';
import 'package:folio/sections/admin/login_screen.dart';
import 'package:folio/services/auth_service.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  late PortfolioData _draft;
  bool _saving = false;
  String? _loadedUid;

  @override
  void initState() {
    super.initState();
    _draft = activeData.copy();
    _tab = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _flash(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.c!.primary,
        ),
      );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    setActivePortfolio(_draft);
    try {
      await PortfolioProvider.state(context).save();
      _flash('Portfolio enregistre. Lien public : /p/${_draft.slug}');
    } catch (e) {
      _flash('Erreur : $e');
    }
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _publishSlug() async {
    final slug = _draft.slug.trim();
    setState(() => _saving = true);
    try {
      await PortfolioProvider.state(context).saveToSlug(slug);
      _flash('Lien public publie : /p/$slug');
    } catch (e) {
      _flash('Lien indisponible : $e');
    }
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _reset() async {
    await PortfolioProvider.state(context).resetToDefault();
    setState(() => _draft = activeData.copy());
    _flash('Reinitialise aux donnees par defaut');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.userStream,
      builder: (context, snap) {
        final user = snap.data;
        if (user == null) {
          _loadedUid = null;
          return const LoginScreen();
        }
        if (_loadedUid != user.uid) {
          _loadedUid = user.uid;
          _draft = activeData.copy();
        }
        return _buildEditor(ValueKey(user.uid));
      },
    );
  }

  Widget _buildEditor(Key key) {
    final p = PortfolioProvider.state(context);
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('Portfolio Studio'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.restart_alt),
            label: const Text('Défaut'),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload_outlined, size: 18),
              label: const Text('Enregistrer'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.c!.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _publicBar(p.currentSlug ?? ''),
          TabBar(
            controller: _tab,
            isScrollable: true,
            labelColor: const Color(0xffC0392B),
            unselectedLabelColor: AppTheme.c!.textSub2,
            indicatorColor: const Color(0xffC0392B),
            indicatorWeight: 3,
            labelStyle: AppText.b1b,
            tabs: const [
              Tab(text: 'Profil'),
              Tab(text: 'Compétences'),
              Tab(text: 'Expériences'),
              Tab(text: 'Projets'),
              Tab(text: 'Formation'),
              Tab(text: 'Contact'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _profileTab(),
                _skillsTab(),
                _sizedList(_ExperiencesEditor(
                  items: _draft.experiences,
                  onChanged: () => setState(() {}),
                )),
                _sizedList(_ProjectsEditor(
                  items: _draft.projects,
                  onChanged: () => setState(() {}),
                )),
                _sizedList(_EducationEditor(
                  items: _draft.education,
                  onChanged: () => setState(() {}),
                )),
                _sizedList(_contactTab()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: AppTheme.c!.backgroundSub,
        child: SafeArea(
          child: Center(
            child: TextButton.icon(
              onPressed: () async {
                await AuthService.instance.signOut();
                if (mounted) Navigator.of(context).pop();
              },
              icon: const Icon(Icons.logout, size: 16),
              label: const Text('Se déconnecter'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sizedList(Widget child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: child,
        ),
      ),
    );
  }

  Widget _publicBar(String slug) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      color: AppTheme.c!.backgroundSub,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(Icons.link, size: 16, color: Color(0xffC0392B)),
                Text('/p/$slug', style: AppText.b1),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: '/p/$slug'));
                    _flash('Lien copie');
                  },
                  child: const Icon(
                    Icons.copy,
                    size: 14,
                    color: Color(0xffC0392B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileTab() {
    final d = _draft;
    return _sizedList(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(title: 'Identité', icon: Icons.person_outline),
          _pad(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AdminField(
                    label: 'Prénom',
                    icon: Icons.person,
                    initial: d.name,
                    onChanged: (v) => setState(() => d.name = v),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: AdminField(
                    label: 'Nom',
                    icon: Icons.badge_outlined,
                    initial: d.surname,
                    onChanged: (v) => setState(() => d.surname = v),
                  ),
                ),
              ],
            ),
          ),
          _pad(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AdminField(
                    label: 'Âge',
                    icon: Icons.cake_outlined,
                    initial: d.age,
                    onChanged: (v) => setState(() => d.age = v),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: AdminField(
                    label: 'Pays',
                    icon: Icons.place_outlined,
                    initial: d.location,
                    onChanged: (v) => setState(() => d.location = v),
                  ),
                ),
              ],
            ),
          ),
          _pad(
            AdminField(
              label: 'Email public',
              icon: Icons.mail_outline,
              initial: d.email,
              keyboard: TextInputType.emailAddress,
              onChanged: (v) => setState(() => d.email = v),
            ),
          ),
          _pad(
            AdminField(
              label: 'Téléphone (WhatsApp)',
              icon: Icons.phone_outlined,
              initial: d.phone,
              keyboard: TextInputType.phone,
              onChanged: (v) => setState(() => d.phone = v),
            ),
          ),
          const SizedBox(height: 28),
          const _SectionTitle(title: 'Message d’accueil', icon: Icons.title),
          _pad(
            AdminField(
              label: 'Titre sous le nom (headline)',
              icon: Icons.notes,
              initial: d.headline,
              maxLines: 2,
              onChanged: (v) => setState(() => d.headline = v),
            ),
          ),
          _pad(
            AdminField(
              label: '« About Me » (paragraphe détaillé)',
              icon: Icons.article_outlined,
              initial: d.aboutMeDetail,
              maxLines: 8,
              onChanged: (v) => setState(() => d.aboutMeDetail = v),
            ),
          ),
          const SizedBox(height: 28),
          const _SectionTitle(
            title: 'Photos',
            icon: Icons.photo_library_outlined,
          ),
          _pad(
            Column(
              children: [
                PhotoField(
                  label: 'Photo principale (couleur)',
                  value: d.photoColored,
                  defaultValue: 'assets/photos/colored.png',
                  onChanged: (v) => setState(() => d.photoColored = v),
                ),
                const SizedBox(height: 12),
                PhotoField(
                  label: 'Photo noir & blanc',
                  value: d.photoBlackWhite,
                  defaultValue: 'assets/photos/black-white.png',
                  onChanged: (v) => setState(() => d.photoBlackWhite = v),
                ),
                const SizedBox(height: 12),
                PhotoField(
                  label: 'Photo mobile',
                  value: d.photoMobile,
                  defaultValue: 'assets/photos/mobile.png',
                  onChanged: (v) => setState(() => d.photoMobile = v),
                ),
                const SizedBox(height: 12),
                PhotoField(
                  label: 'Avatar (menu / drawer)',
                  value: d.avatar,
                  defaultValue: 'assets/photos/colored.png',
                  onChanged: (v) => setState(() => d.avatar = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const _SectionTitle(title: 'Liens', icon: Icons.insert_link),
          _pad(
            AdminField(
              label: 'CV (URL du PDF)',
              icon: Icons.description_outlined,
              initial: d.resumeUrl,
              isUrl: true,
              keyboard: TextInputType.url,
              onChanged: (v) => setState(() => d.resumeUrl = v),
            ),
          ),
          _pad(
            AdminField(
              label: 'GitHub',
              icon: Icons.code,
              initial: d.githubUrl,
              isUrl: true,
              keyboard: TextInputType.url,
              onChanged: (v) => setState(() => d.githubUrl = v),
            ),
          ),
          const SizedBox(height: 28),
          const _SectionTitle(title: 'Publication', icon: Icons.public),
          _pad(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AdminField(
                    label: 'Lien personnalisé (slug)',
                    icon: Icons.link,
                    initial: d.slug,
                    onChanged: (v) => setState(() => d.slug = v),
                  ),
                ),
                const SizedBox(width: 14),
                FilledButton.icon(
                  onPressed: _saving ? null : _publishSlug,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.c!.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                  ),
                  icon: const Icon(Icons.publish, size: 18),
                  label: const Text('Publier'),
                ),
              ],
            ),
          ),
          _pad(
            Text(
              'Partagez /p/${d.slug} pour afficher votre portfolio public.',
              style: AppText.l1?.copyWith(color: AppTheme.c!.textSub2),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _skillsTab() {
    final d = _draft;
    return _sizedList(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            title: 'Rôles (texte animé sur l’accueil)',
            icon: Icons.auto_awesome,
          ),
          _pad(
            TagListEditor(
              label: 'Rôles',
              icon: Icons.play_arrow,
              tags: d.roles,
              onChanged: (v) => setState(() => d.roles = v),
            ),
          ),
          const SizedBox(height: 28),
          const _SectionTitle(
            title: 'Compétences (technologies)',
            icon: Icons.settings_suggest,
          ),
          _pad(
            TagListEditor(
              label: 'Compétences',
              icon: Icons.build_outlined,
              tags: d.skills,
              onChanged: (v) => setState(() => d.skills = v),
            ),
          ),
          const SizedBox(height: 28),
          const _SectionTitle(title: 'Services', icon: Icons.star_outline),
          _ServicesEditor(
            items: d.services,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _contactTab() {
    final d = _draft;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(title: 'Coordonnées', icon: Icons.contact_mail),
        _ContactsEditor(
          items: d.contacts,
          onChanged: () => setState(() {}),
        ),
        const SizedBox(height: 28),
        const _SectionTitle(
          title: 'Réseaux sociaux',
          icon: Icons.share_outlined,
        ),
        _SocialsEditor(
          items: d.socials,
          onChanged: () => setState(() {}),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _pad(Widget child) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: child,
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.c!.primary),
        const SizedBox(width: 8),
        Text(title.toUpperCase(), style: AppText.b1b),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.onDelete,
    required this.cardKey,
  });

  final Key cardKey;
  final int index;
  final String title;
  final String subtitle;
  final Widget body;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: cardKey,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.withOpacity(0.25)),
      ),
      color: AppTheme.c!.backgroundSub,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.c!.primary,
          child: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        title: Text(
          title.isEmpty ? '(Sans nom)' : title,
          style: AppText.b1b,
        ),
        subtitle: Text(subtitle, style: AppText.l1),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [body],
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 18),
              color: AppTheme.c!.primary,
              tooltip: 'Supprimer',
            ),
            const Icon(Icons.expand_more),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppTheme.c!.primary!),
          foregroundColor: AppTheme.c!.primary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
        icon: const Icon(Icons.add, size: 18),
        label: Text(label),
      ),
    );
  }
}

class _ExperiencesEditor extends StatelessWidget {
  const _ExperiencesEditor({required this.items, required this.onChanged});

  final List<ExperienceItem> items;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty) const EmptyHint(text: 'Aucune expérience.'),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _Tile(
              cardKey: ObjectKey(items[i]),
              index: i,
              title: items[i].position,
              subtitle: items[i].company,
              onDelete: () {
                items.removeAt(i);
                onChanged();
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdminField(
                    label: 'Poste',
                    icon: Icons.work_outline,
                    initial: items[i].position,
                    onChanged: (v) {
                      items[i].position = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  AdminField(
                    label: 'Entreprise',
                    icon: Icons.business_center_outlined,
                    initial: items[i].company,
                    onChanged: (v) {
                      items[i].company = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  AdminField(
                    label: 'Période (ex : 2020 — 2023)',
                    icon: Icons.date_range,
                    initial: items[i].duration,
                    onChanged: (v) {
                      items[i].duration = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  AdminField(
                    label: 'Description',
                    icon: Icons.notes,
                    initial: items[i].description,
                    maxLines: 5,
                    onChanged: (v) {
                      items[i].description = v;
                      onChanged();
                    },
                  ),
                ],
              ),
            ),
          ),
        _AddButton(
          label: 'Ajouter une expérience',
          onPressed: () {
            items.add(ExperienceItem(
              position: '',
              company: '',
              duration: '',
              description: '',
            ));
            onChanged();
          },
        ),
      ],
    );
  }
}

class _ProjectsEditor extends StatelessWidget {
  const _ProjectsEditor({required this.items, required this.onChanged});

  final List<ProjectItem> items;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty) const EmptyHint(text: 'Aucun projet.'),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _Tile(
              cardKey: ObjectKey(items[i]),
              index: i,
              title: items[i].title,
              subtitle: items[i].description.length > 60
                  ? items[i].description.substring(0, 60)
                  : items[i].description,
              onDelete: () {
                items.removeAt(i);
                onChanged();
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PhotoField(
                    label: 'Image de couverture',
                    value: items[i].banner,
                    onChanged: (v) {
                      items[i].banner = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  PhotoField(
                    label: 'Icône / logo',
                    value: items[i].icon,
                    onChanged: (v) {
                      items[i].icon = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  AdminField(
                    label: 'Titre',
                    icon: Icons.title,
                    initial: items[i].title,
                    onChanged: (v) {
                      items[i].title = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  AdminField(
                    label: 'Description',
                    icon: Icons.notes,
                    initial: items[i].description,
                    maxLines: 4,
                    onChanged: (v) {
                      items[i].description = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  AdminField(
                    label: 'Lien du projet',
                    icon: Icons.insert_link,
                    initial: items[i].link,
                    isUrl: true,
                    keyboard: TextInputType.url,
                    onChanged: (v) {
                      items[i].link = v;
                      onChanged();
                    },
                  ),
                ],
              ),
            ),
          ),
        _AddButton(
          label: 'Ajouter un projet',
          onPressed: () {
            items.add(ProjectItem(
              banner: 'assets/projects/mon-classe/cover.png',
              icon: 'assets/projects/mon-classe/icon.png',
              title: '',
              description: '',
              link: '',
            ));
            onChanged();
          },
        ),
      ],
    );
  }
}

class _EducationEditor extends StatelessWidget {
  const _EducationEditor({required this.items, required this.onChanged});

  final List<EducationItem> items;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty) const EmptyHint(text: 'Aucune formation.'),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _Tile(
              cardKey: ObjectKey(items[i]),
              index: i,
              title: items[i].title,
              subtitle: items[i].description.length > 60
                  ? items[i].description.substring(0, 60)
                  : items[i].description,
              onDelete: () {
                items.removeAt(i);
                onChanged();
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PhotoField(
                    label: 'Image de couverture',
                    value: items[i].banner,
                    onChanged: (v) {
                      items[i].banner = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  PhotoField(
                    label: 'Icône',
                    value: items[i].icon,
                    onChanged: (v) {
                      items[i].icon = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  AdminField(
                    label: 'Diplôme / établissement',
                    icon: Icons.school_outlined,
                    initial: items[i].title,
                    onChanged: (v) {
                      items[i].title = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  AdminField(
                    label: 'Description',
                    icon: Icons.notes,
                    initial: items[i].description,
                    maxLines: 4,
                    onChanged: (v) {
                      items[i].description = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  AdminField(
                    label: 'Attestation (lien)',
                    icon: Icons.insert_link,
                    initial: items[i].link,
                    isUrl: true,
                    keyboard: TextInputType.url,
                    onChanged: (v) {
                      items[i].link = v;
                      onChanged();
                    },
                  ),
                ],
              ),
            ),
          ),
        _AddButton(
          label: 'Ajouter une formation',
          onPressed: () {
            items.add(EducationItem(
              banner: 'assets/photos/mobile.png',
              icon: 'assets/photos/black-white.png',
              title: '',
              description: '',
              link: '',
            ));
            onChanged();
          },
        ),
      ],
    );
  }
}

class _ServicesEditor extends StatelessWidget {
  const _ServicesEditor({required this.items, required this.onChanged});

  final List<ServiceItem> items;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty) const EmptyHint(text: 'Aucun service.'),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _Tile(
              cardKey: ObjectKey(items[i]),
              index: i,
              title: items[i].title,
              subtitle: items[i].description,
              onDelete: () {
                items.removeAt(i);
                onChanged();
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdminField(
                    label: 'Titre du service',
                    icon: Icons.star_outline,
                    initial: items[i].title,
                    onChanged: (v) {
                      items[i].title = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  AdminField(
                    label: 'Description',
                    icon: Icons.notes,
                    initial: items[i].description,
                    maxLines: 3,
                    onChanged: (v) {
                      items[i].description = v;
                      onChanged();
                    },
                  ),
                ],
              ),
            ),
          ),
        _AddButton(
          label: 'Ajouter un service',
          onPressed: () {
            items.add(ServiceItem(title: '', description: ''));
            onChanged();
          },
        ),
      ],
    );
  }
}

class _ContactsEditor extends StatelessWidget {
  const _ContactsEditor({required this.items, required this.onChanged});

  final List<ContactItem> items;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty) const EmptyHint(text: 'Aucune coordonnée.'),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _Tile(
              cardKey: ObjectKey(items[i]),
              index: i,
              title: items[i].title,
              subtitle: items[i].detail,
              onDelete: () {
                items.removeAt(i);
                onChanged();
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdminField(
                    label: 'Titre (ex : Appelez-moi)',
                    icon: Icons.title,
                    initial: items[i].title,
                    onChanged: (v) {
                      items[i].title = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  AdminField(
                    label: 'Détail',
                    icon: Icons.notes,
                    initial: items[i].detail,
                    maxLines: 3,
                    onChanged: (v) {
                      items[i].detail = v;
                      onChanged();
                    },
                  ),
                ],
              ),
            ),
          ),
        _AddButton(
          label: 'Ajouter une coordonnée',
          onPressed: () {
            items.add(ContactItem(title: '', detail: ''));
            onChanged();
          },
        ),
      ],
    );
  }
}

class _SocialsEditor extends StatelessWidget {
  const _SocialsEditor({required this.items, required this.onChanged});

  final List<SocialItem> items;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty) const EmptyHint(text: 'Aucun réseau social.'),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _Tile(
              cardKey: ObjectKey(items[i]),
              index: i,
              title: items[i].name,
              subtitle: items[i].url,
              onDelete: () {
                items.removeAt(i);
                onChanged();
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdminField(
                    label: 'Nom (ex : GitHub)',
                    icon: Icons.alternate_email,
                    initial: items[i].name,
                    onChanged: (v) {
                      items[i].name = v;
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 10),
                  AdminField(
                    label: 'URL',
                    icon: Icons.insert_link,
                    initial: items[i].url,
                    isUrl: true,
                    keyboard: TextInputType.url,
                    onChanged: (v) {
                      items[i].url = v;
                      onChanged();
                    },
                  ),
                ],
              ),
            ),
          ),
        _AddButton(
          label: 'Ajouter un réseau social',
          onPressed: () {
            items.add(SocialItem(name: '', url: ''));
            onChanged();
          },
        ),
      ],
    );
  }
}