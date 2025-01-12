import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'kitap_guncelle_ekrani.dart'; 

class KitapListeEkrani extends StatelessWidget {
  const KitapListeEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final kullaniciId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Kitap Listesi"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('kitaplar')
            .where('userId', isEqualTo: kullaniciId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> anlikGoruntu) {
          if (!anlikGoruntu.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final kitaplar = anlikGoruntu.data!.docs;

          if (kitaplar.isEmpty) {
            return Center(child: Text("Henüz kitap eklenmedi."));
          }

          return ListView.builder(
            itemCount: kitaplar.length,
            itemBuilder: (context, index) {
              final kitap = kitaplar[index];
              final dosyaId = kitap.id;

              return ListTile(
                title: Text(kitap['kitapAdi']),
                subtitle: Text("Yazar: ${kitap['yazarAdi']}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KitapGuncelleEkrani(kitapId: dosyaId),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('favoriler')
                          .doc(dosyaId)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot> favAnlikGoruntu) {
                        final isFavorite = favAnlikGoruntu.data?.exists ?? false;

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
                                  .doc(dosyaId)
                                  .delete();
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('favoriler')
                                  .doc(dosyaId)
                                  .set({
                                'kitapAdi': kitap['kitapAdi'],
                                'yazarAdi': kitap['yazarAdi'],
                                'ozet': kitap['ozet'],
                                'userId': kullaniciId,
                              });
                            }
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _silmeOnayiGoster(context, dosyaId),
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

  void _silmeOnayiGoster(BuildContext context, String dosyaId) {
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
                    .doc(dosyaId)
                    .delete();

                await FirebaseFirestore.instance
                    .collection('favoriler')
                    .doc(dosyaId)
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
