import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavorilerEkrani extends StatelessWidget {
  const FavorilerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorilerim"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('favoriler')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final favorites = snapshot.data!.docs;

          if (favorites.isEmpty) {
            return Center(
                child: Text("Henüz favorilere eklenmiş kitap yok maalesef."));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final kitap = favorites[index];
              final docId = kitap.id;

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
                        .doc(docId)
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
