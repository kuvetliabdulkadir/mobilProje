import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavorilerEkrani extends StatelessWidget {
  const FavorilerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final kullaniciId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorilerim"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('favoriler')
            .where('userId', isEqualTo: kullaniciId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> anlikGoruntu) {
          if (!anlikGoruntu.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final favoriler = anlikGoruntu.data!.docs;

          if (favoriler.isEmpty) {
            return Center(
                child: Text("Henüz favorilere eklenmiş kitap yok maalesef."));
          }

          return ListView.builder(
            itemCount: favoriler.length,
            itemBuilder: (context, index) {
              final kitap = favoriler[index];
              final dosyaId = kitap.id;

              return ListTile(
                title: Text(kitap['kitapAdi']),
                subtitle: Text("Yazar: ${kitap['yazarAdi']}"),
                trailing: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: const Color.fromARGB(255, 147, 150, 3),
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('favoriler')
                        .doc(dosyaId)
                        .delete();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
