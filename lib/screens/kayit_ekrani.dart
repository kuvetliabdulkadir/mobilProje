import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_library/screens/giris_ekrani.dart';

class KayitEkrani extends StatelessWidget {
  final TextEditingController adController = TextEditingController();
  final TextEditingController soyadController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController parolaController = TextEditingController();

  KayitEkrani({super.key});

  void register(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: parolaController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt başarılı!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GirisEkrani()),
      );
    } catch (a) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt başarısız! Lütfen yeniden deneyin.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assests/indir.jpg",
                width: 300,
                height: 100,
              ), // Resim
              TextField(
                style: TextStyle(color: const Color.fromARGB(255, 0, 121, 219)),
                cursorColor: Colors.blue,
                controller: adController,
                decoration: InputDecoration(labelText: 'Adınız'),
              ),
              TextField(
                style: TextStyle(color: const Color.fromARGB(255, 0, 121, 219)),
                cursorColor: Colors.blue,
                controller: soyadController,
                decoration: InputDecoration(labelText: 'Soyadınız'),
              ),
              TextField(
                style: TextStyle(color: const Color.fromARGB(255, 0, 121, 219)),
                cursorColor: Colors.blue,
                controller: emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
              TextField(
                style: TextStyle(color: const Color.fromARGB(255, 0, 121, 219)),
                cursorColor: Colors.blue,
                controller: parolaController,
                decoration: InputDecoration(labelText: 'Parola'),
                obscureText: true,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 255, 255)),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 121, 174, 235)),
                ),
                onPressed: () => register(context),
                child: Text('Kayıt Ol'),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 255, 255)),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 121, 174, 235)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GirisEkrani()),
                  );
                },
                child: Text('Giriş'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
