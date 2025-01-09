import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'kitap_guncelle_ekrani.dart'; // Kitap güncelleme ekranını ekliyoruz.

class KitapListeEkrani extends StatelessWidget {
  const KitapListeEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Kitap Listesi"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('kitaplar')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data!.docs;

          if (books.isEmpty) {
            return Center(child: Text("Henüz kitap eklenmedi."));
          }

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final docId = book.id;

              return ListTile(
                title: Text(book['kitapAdi']),
                subtitle: Text("Yazar: ${book['yazarAdi']}"),
                onTap: () {
                  // Kitap bilgilerini güncelleyebileceğiniz sayfaya yönlendiriyoruz
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KitapGuncelleEkrani(bookId: docId),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('favoriler')
                          .doc(docId)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot> favSnapshot) {
                        final isFavorite = favSnapshot.data?.exists ?? false;

                        return IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: isFavorite
                                ? Color.fromARGB(255, 147, 150, 3)
                                : Colors.grey,
                          ),
                          onPressed: () async {
                            if (isFavorite) {
                              await FirebaseFirestore.instance
                                  .collection('favoriler')
                                  .doc(docId)
                                  .delete();
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('favoriler')
                                  .doc(docId)
                                  .set({
                                'kitapAdi': book['kitapAdi'],
                                'yazarAdi': book['yazarAdi'],
                                'ozet': book['ozet'],
                                'userId': userId,
                              });
                            }
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _silmeOnayiGoster(context, docId),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _silmeOnayiGoster(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Kitabı Sil"),
        content: Text("Bu kitabı silmek istediğinizden emin misiniz? "),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Elim Çarptı."),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('kitaplar')
                    .doc(docId)
                    .delete();

                await FirebaseFirestore.instance
                    .collection('favoriler')
                    .doc(docId)
                    .delete();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Kitap başarıyla silindi!")),
                );
              } catch (a) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Bir hata oluştu: ")),
                );
              }
            },
            child: Text("Kitabı Sil."),
          ),
        ],
      ),
    );
  }
}
