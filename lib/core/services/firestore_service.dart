import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/meal.dart';

/// Singleton: one shared Firestore gateway for user-scoped persistence.
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Authentication required');
    return user.uid;
  }

  DocumentReference<Map<String, dynamic>> get _user =>
      _db.collection('users').doc(uid);
  Stream<DocumentSnapshot<Map<String, dynamic>>> profile() => _user.snapshots();
  Future<void> saveProfile(AppUser profile) => _user.set({
        'id': profile.id,
        'name': profile.name,
        'email': profile.email,
        if (profile.photoUrl != null) 'photoUrl': profile.photoUrl,
        'updatedAt': FieldValue.serverTimestamp()
      }, SetOptions(merge: true));
  Future<void> savePhotoUrl(String url) =>
      _user.set({'photoUrl': url}, SetOptions(merge: true));
  Stream<QuerySnapshot<Map<String, dynamic>>> favourites() =>
      _user.collection('favourites').snapshots();
  Future<void> toggleFavourite(Meal meal) async {
    final doc = _user.collection('favourites').doc(meal.id);
    if ((await doc.get()).exists) {
      await doc.delete();
    } else {
      await doc.set({
        'id': meal.id,
        'name': meal.name,
        'image': meal.image,
        'category': meal.category,
        'area': meal.area,
        'instructions': meal.instructions,
        'price': meal.price
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> orders() => _user
      .collection('orders')
      .orderBy('createdAt', descending: true)
      .snapshots();
  Future<void> placeOrder(List<Meal> meals,
      {required String paymentMethod}) async {
    if (meals.isEmpty) throw StateError('Empty cart');
    await _user.collection('orders').add({
      'items': meals
          .map((m) =>
              {'id': m.id, 'name': m.name, 'price': m.price, 'image': m.image})
          .toList(),
      'total': meals.fold<double>(0, (total, meal) => total + meal.price),
      'paymentMethod': paymentMethod,
      'status': 'placed',
      'createdAt': FieldValue.serverTimestamp()
    });
  }
}
