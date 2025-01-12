import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KitapGuncelleEkrani extends StatefulWidget {
  final String kitapId;

  const KitapGuncelleEkrani({required this.kitapId, super.key});

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

  void _kitapVerileriniYukle() async {
    var dosyaAnlikGoruntu = await FirebaseFirestore.instance
        .collection('kitaplar')
        .doc(widget.kitapId)
        .get();
    if (dosyaAnlikGoruntu.exists) {
      _kitapAdiController.text = dosyaAnlikGoruntu['kitapAdi'];
      _yazarAdiController.text = dosyaAnlikGoruntu['yazarAdi'];
      _ozetController.text = dosyaAnlikGoruntu['ozet'] ?? '';
    }
  }

  Future<void> _kitabiGuncelle() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseFirestore.instance
            .collection('kitaplar')
            .doc(widget.kitapId)
            .update({
          'kitapAdi': _kitapAdiController.text.trim(),
          'yazarAdi': _yazarAdiController.text.trim(),
          'ozet': _ozetController.text.trim().isNotEmpty
              ? _ozetController.text.trim()
              : null,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kitap başarıyla güncellendi!")),
        );
        Navigator.pop(context);
      } catch (a) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bir hata oluştu: ${a.toString()}")),
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
                decoration:
                    InputDecoration(labelText: 'Özet veya Sevdiğim Bölüm'),
                maxLines: 5,
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
