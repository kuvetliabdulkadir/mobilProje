import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KitapGuncelleEkrani extends StatefulWidget {
  final String bookId;

  const KitapGuncelleEkrani({required this.bookId, super.key});

  @override
  _KitapGuncelleEkraniState createState() => _KitapGuncelleEkraniState();
}

class _KitapGuncelleEkraniState extends State<KitapGuncelleEkrani> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _kitapAdiController;
  late TextEditingController _yazarAdiController;
  late TextEditingController _ozetController;

  @override
  void initState() {
    super.initState();
    _kitapAdiController = TextEditingController();
    _yazarAdiController = TextEditingController();
    _ozetController = TextEditingController();
    _kitapVerileriniYukle();
  }

  // Kitap verilerini yükler
  void _kitapVerileriniYukle() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('kitaplar')
        .doc(widget.bookId)
        .get();
    if (docSnapshot.exists) {
      _kitapAdiController.text = docSnapshot['kitapAdi'];
      _yazarAdiController.text = docSnapshot['yazarAdi'];
      _ozetController.text = docSnapshot['ozet'];
    }
  }

  // Kitap bilgilerini günceller
  Future<void> _kitabiGuncelle() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseFirestore.instance
            .collection('kitaplar')
            .doc(widget.bookId)
            .update({
          'kitapAdi': _kitapAdiController.text,
          'yazarAdi': _yazarAdiController.text,
          'ozet': _ozetController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kitap başarıyla güncellendi!")),
        );
        Navigator.pop(context);
      } catch (a) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bir hata oluştu!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kitap Bilgilerini Güncelle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _kitapAdiController,
                decoration: InputDecoration(labelText: 'Kitap Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kitap adı gereklidir';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _yazarAdiController,
                decoration: InputDecoration(labelText: 'Yazar Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yazar adı gereklidir';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ozetController,
                decoration: InputDecoration(labelText: 'Özet'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Özet gereklidir';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _kitabiGuncelle,
                child: Text("Güncelle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
