import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bhajan.dart';
import '../models/category.dart';
import '../models/gita_quote.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Bhajan>> fetchAllPublishedBhajans() async {
    final snapshot = await _firestore
        .collection('bhajans')
        .where('is_published', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => Bhajan.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  Future<List<Category>> fetchAllCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs
        .map((doc) => Category.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  Future<List<GitaQuote>> fetchAllGitaQuotes() async {
    final snapshot = await _firestore
        .collection('gita_quotes')
        .where('is_active', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => GitaQuote.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  Future<List<Bhajan>> fetchBhajansUpdatedAfter(int timestamp) async {
    final snapshot = await _firestore
        .collection('bhajans')
        .where('is_published', isEqualTo: true)
        .where(
          'updated_at',
          isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(timestamp),
        )
        .get();
    return snapshot.docs
        .map((doc) => Bhajan.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}
