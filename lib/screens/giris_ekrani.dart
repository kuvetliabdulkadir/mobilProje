import 'package:flutter/material.dart';
import 'package:my_library/screens/ana_ekran.dart';
import 'package:my_library/screens/kayit_ekrani.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GirisEkrani extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController parolaController = TextEditingController();

  GirisEkrani({super.key});

  void giris(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: parolaController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarılı.')),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AnaEkran()));
    } catch (a) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarısız.\nLütfen Yeniden Deneyiniz.')),
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
                height: 200,
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
                child: Text('Giriş'),
                onPressed: () => giris(context),
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
                    MaterialPageRoute(builder: (context) => KayitEkrani()),
                  );
                },
                child: Text('Kayıt Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
