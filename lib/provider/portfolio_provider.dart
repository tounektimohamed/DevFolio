import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../data/active_data.dart';
import '../data/default_portfolio.dart';
import '../models/portfolio_data.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

enum PortfolioMode { loading, owner, public, error }

class PortfolioProvider extends ChangeNotifier {
  PortfolioProvider._();
  static PortfolioProvider? _instance;

  static PortfolioProvider ensureInstance() {
    _instance ??= PortfolioProvider._();
    return _instance!;
  }

  static PortfolioProvider state(BuildContext context, [bool listen = false]) =>
      Provider.of<PortfolioProvider>(context, listen: listen);

  PortfolioMode _mode = PortfolioMode.loading;
  PortfolioMode get mode => _mode;

  String? error;
  String? currentSlug;

  bool get isOwnerMode => _mode == PortfolioMode.owner;
  bool get isPublicMode => _mode == PortfolioMode.public;

  Future<void> bootstrap({String? uid}) async {
    _mode = PortfolioMode.loading;
    notifyListeners();
    try {
      if (uid != null && uid.isNotEmpty) {
        final data = await FirestoreService.instance.loadOwner(uid);
        if (data != null) {
          setActivePortfolio(data);
          _mode = PortfolioMode.owner;
          currentSlug = data.slug;
          notifyListeners();
          return;
        }
      }
      await _loadDefaultOwner();
      _mode = PortfolioMode.owner;
      currentSlug = activeData.slug;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      _mode = PortfolioMode.error;
      notifyListeners();
    }
  }

  Future<void> _loadDefaultOwner() async {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      setActivePortfolio(buildDefaultPortfolio());
      return;
    }
    final data = await FirestoreService.instance.loadOwner(user.uid);
    setActivePortfolio(data ?? buildDefaultPortfolio());
  }

  Future<void> loadPublic(String slug) async {
    _mode = PortfolioMode.loading;
    notifyListeners();
    try {
      final data = await FirestoreService.instance.loadBySlug(slug);
      if (data == null) {
        error = 'Portfolio not found for slug "$slug"';
        _mode = PortfolioMode.error;
        notifyListeners();
        return;
      }
      setActivePortfolio(data);
      currentSlug = slug;
      _mode = PortfolioMode.public;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      _mode = PortfolioMode.error;
      notifyListeners();
    }
  }

  Future<void> save() async {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      throw Exception('Not authenticated');
    }
    final data = activeData.copy();
    await FirestoreService.instance.saveOwner(user.uid, data);
    setActivePortfolio(data);
    currentSlug = data.slug;
    notifyListeners();
  }

  Future<void> saveToSlug(String slug) async {
    final avail = await FirestoreService.instance
        .slugAvailable(slug, exceptUid: AuthService.instance.currentUser?.uid);
    if (!avail) {
      throw Exception('Slug "$slug" is already taken.');
    }
    activeData.slug = slug;
    await save();
  }

  Future<void> resetToDefault() async {
    setActivePortfolio(buildDefaultPortfolio());
    notifyListeners();
  }
}