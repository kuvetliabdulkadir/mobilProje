import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServisi {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı kimliğini al
  String? get currentUserId => _auth.currentUser?.uid;

  // Kullanıcı giriş yap
  Future<void> girisYap({required String email, required String sifre}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: sifre);
  }

  // Kitap ekle
  Future<void> kitapEkle({
    required String kitapAdi,
    required String yazarAdi,
    String? ozet,
  }) async {
    if (currentUserId == null) throw Exception("Kullanıcı kimliği alınamadı!");

    await _firestore.collection('kitaplar').add({
      'kitapAdi': kitapAdi,
      'yazarAdi': yazarAdi,
      'ozet': ozet,
      'userId': currentUserId,
    });
  }

  // Kitap güncelle
  Future<void> kitapGuncelle({
    required String bookId,
    required String kitapAdi,
    required String yazarAdi,
    String? ozet,
  }) async {
    await _firestore.collection('kitaplar').doc(bookId).update({
      'kitapAdi': kitapAdi,
      'yazarAdi': yazarAdi,
      'ozet': ozet,
    });
  }

  // Kitap sil
  Future<void> kitapSil(String bookId) async {
    await _firestore.collection('kitaplar').doc(bookId).delete();
  }

  // Kullanıcının kitaplarını listele
  Stream<QuerySnapshot> kullaniciKitaplariniGetir() {
    if (currentUserId == null) throw Exception("Kullanıcı kimliği alınamadı!");

    return _firestore
        .collection('kitaplar')
        .where('userId', isEqualTo: currentUserId)
        .snapshots();
  }

  // Kullanıcının favorilerini listele
  Stream<QuerySnapshot> kullaniciFavorileriniGetir() {
    if (currentUserId == null) throw Exception("Kullanıcı kimliği alınamadı!");

    return _firestore
        .collection('favoriler')
        .where('userId', isEqualTo: currentUserId)
        .snapshots();
  }

  // Favori ekle/kaldır
  Future<void> favoriEkleKaldir({
    required String bookId,
    required bool isFavorite,
    required String kitapAdi,
    required String yazarAdi,
    String? ozet,
  }) async {
    final docRef = _firestore.collection('favoriler').doc(bookId);

    if (isFavorite) {
      await docRef.delete();
    } else {
      await docRef.set({
        'kitapAdi': kitapAdi,
        'yazarAdi': yazarAdi,
        'ozet': ozet,
        'userId': currentUserId,
      });
    }
  }

  // Eğer varsa favoriyi sil
  Future<void> favoriyiSilEgerVarsa(String bookId) async {
    final docRef = _firestore.collection('favoriler').doc(bookId);

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.delete();
    }
  }

  // Belirli bir kitabı getir
  Future<DocumentSnapshot?> kitapGetirById(String bookId) async {
    return await _firestore.collection('kitaplar').doc(bookId).get();
  }
}
