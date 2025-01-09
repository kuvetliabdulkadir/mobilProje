import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KitapEklemeEkrani extends StatelessWidget {
  final TextEditingController kitapAdiController = TextEditingController();
  final TextEditingController yazarAdiController = TextEditingController();
  final TextEditingController ozetController = TextEditingController();

  KitapEklemeEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kitap Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: kitapAdiController,
              decoration: InputDecoration(labelText: "Kitap Adı"),
            ),
            TextField(
              controller: yazarAdiController,
              decoration: InputDecoration(labelText: "Yazar Adı"),
            ),
            TextField(
              controller: ozetController,
              decoration: InputDecoration(labelText: "Özet veya Sevdiğim Yer"),
              maxLines: 5,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (kitapAdiController.text.isNotEmpty &&
                      yazarAdiController.text.isNotEmpty) {
                    final userId = FirebaseAuth.instance.currentUser?.uid;

                    if (userId != null) {
                      await FirebaseFirestore.instance
                          .collection('kitaplar')
                          .add({
                        'kitapAdi': kitapAdiController.text,
                        'yazarAdi': yazarAdiController.text,
                        'ozet': ozetController.text.isNotEmpty
                            ? ozetController.text
                            : null,
                        'userId': userId,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Kitap başarıyla eklendi!")),
                      );

                      kitapAdiController.clear();
                      yazarAdiController.clear();
                      ozetController.clear();

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Kullanıcı kimliği alınamadı!")),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Kitap adı ve yazar adı zorunludur!")),
                    );
                  }
                } catch (a) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Bir hata oluştu: ")),
                  );
                }
              },
              child: Text("Ekle"),
            ),
          ],
        ),
      ),
    );
  }
}
