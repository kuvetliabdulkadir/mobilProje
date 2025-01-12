import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_library/screens/favoriler_ekrani.dart';
import 'package:my_library/screens/kitap_ekleme_ekrani.dart';
import 'package:my_library/screens/kitap_liste_ekrani.dart';
import 'package:my_library/screens/giris_ekrani.dart';

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  final TextEditingController aramaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kitap Arama"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: Image.asset('assests/indir.jpg', fit: BoxFit.cover),
            ),
            ListTile(
              title: Text("Ana Ekran"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Favorilerim"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavorilerEkrani()),
                );
              },
            ),
            ListTile(
              title: Text("Kitap Listem"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KitapListeEkrani()),
                );
              },
            ),
            ListTile(
              title: Text("Kitap Ekle"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KitapEklemeEkrani()),
                );
              },
            ),
            ListTile(
              title: Text("Çıkış"),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => GirisEkrani()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            ListTile(
              title: Text("Hesabı Sil"),
              textColor: Color.fromARGB(255, 226, 11, 11),
              onTap: () async {
                final kullanici = FirebaseAuth.instance.currentUser;
                if (kullanici != null) {
                  final confirmation = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Hesabı Sil"),
                      content: Text(
                          "Hesabınızı ve eklediğiniz tüm kitapları silmek istediğinizden emin misiniz? \n\nBilgilendirme!\nHesabınızı yeniden oluşturduğunuzda verileriniz sıfırlanacaktır."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Elim Çarptı."),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Onaylıyorum."),
                        ),
                      ],
                    ),
                  );

                  if (confirmation != true) return;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        Center(child: CircularProgressIndicator()),
                  );

                  try {
                    final kitaplarQueery = await FirebaseFirestore.instance
                        .collection('kitaplar')
                        .where('userId', isEqualTo: kullanici.uid)
                        .get();

                    final katagori = FirebaseFirestore.instance.batch();
                    for (var doc in kitaplarQueery.docs) {
                      katagori.delete(doc.reference);
                    }

                    final favorilerQuery = await FirebaseFirestore.instance
                        .collection('favoriler')
                        .where('userId', isEqualTo: kullanici.uid)
                        .get();

                    for (var doc in favorilerQuery.docs) {
                      katagori.delete(doc.reference);
                    }

                    await katagori.commit();
                    await kullanici.delete();

                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => GirisEkrani()),
                      (Route<dynamic> route) => false,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Hesabınız ve tüm verileriniz silindi.\nYeniden görüşmek dileğiyle...")),
                    );
                  } catch (a) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Bir sorun oluştu.")),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: aramaController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Kitap Ara',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('kitaplar')
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> anlikGoruntu) {
                if (!anlikGoruntu.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final filtrelenmisDosya = anlikGoruntu.data!.docs.where((doc) {
                  final kitapAdi = doc['kitapAdi'].toString().toLowerCase();
                  final aramaText = aramaController.text.toLowerCase();
                  return kitapAdi.contains(aramaText);
                }).toList();

                if (filtrelenmisDosya.isEmpty) {
                  return Center(
                      child: Text(
                          "  Sonuç bulunamadı aradığınız kitabı\neklediğinizden emin olun lütfen. "));
                }

                return ListView(
                  children: filtrelenmisDosya.map((dosya) {
                    return ListTile(
                      title: Text(dosya['kitapAdi']),
                      subtitle: Text("Yazar: ${dosya['yazarAdi']}"),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(dosya['kitapAdi']),
                            content: Text("Özet: ${dosya['ozet']}"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Kapat"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KitapEklemeEkrani()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
