import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/portfolio_data.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  static const String _portfolios = 'portfolios';
  static const String _public = 'public';

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  Future<PortfolioData?> loadOwner(String uid) async {
    final doc = await _db.collection(_portfolios).doc(uid).get();
    if (!doc.exists) {
      return null;
    }
    return PortfolioData.fromMap(doc.data()!);
  }

  Future<PortfolioData?> loadBySlug(String slug) async {
    final doc = await _db.collection(_public).doc(slug).get();
    if (!doc.exists) {
      return null;
    }
    return PortfolioData.fromMap(doc.data()!);
  }

  Future<void> saveOwner(String uid, PortfolioData data) async {
    final old = await _db.collection(_portfolios).doc(uid).get();
    final oldSlug = old.exists ? (old.data()?['slug'] ?? '') as String : '';

    await _db.collection(_portfolios).doc(uid).set({
      ...data.toMap(),
      'ownerUid': uid,
    });

    await _db.collection(_public).doc(data.slug).set({
      ...data.toMap(),
      'ownerUid': uid,
    });

    if (oldSlug.isNotEmpty && oldSlug != data.slug) {
      try {
        await _db.collection(_public).doc(oldSlug).delete();
      } catch (_) {}
    }
  }

  Future<bool> slugAvailable(String slug, {String? exceptUid}) async {
    if (slug.isEmpty) {
      return false;
    }
    if (slug == 'mohamed') {
      return true;
    }
    final docs = await _db
        .collection(_portfolios)
        .where('slug', isEqualTo: slug)
        .limit(1)
        .get();
    if (docs.docs.isEmpty) {
      return true;
    }
    return exceptUid != null && docs.docs.first.id == exceptUid;
  }
}