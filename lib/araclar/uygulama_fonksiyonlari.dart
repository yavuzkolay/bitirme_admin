//uyari ve error pencerelerinin acilmasini sagliyor

import 'package:bitirme_admin/widgetlar/baslik_metni.dart';
import 'package:bitirme_admin/widgetlar/baslik_metni2.dart';
import 'package:flutter/material.dart';

class UygulamaFonksiyonlari {
  static Future<void> ErrorVeyaUyariDiyalogu({
    required BuildContext context,
    required String baslik,
    bool hata = true,
    required Function fct,
  }) async {
    //uyari kutusu burada olusturuldu
    await showDialog(
      context: context,
      builder: (context) {
        //uyari kutusu olarak diyalog kutusu dondurduk
        return AlertDialog(
          //uyari ve error ekraninin kenarina radius verdik
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                hata ? "gorseller/error.png" : "gorseller/uyari.png",
                height: 60,
                width: 60,
              ),
              const SizedBox(
                height: 15,
              ),
              BaslikMetni2(
                metin: baslik,
                fontKalinlik: FontWeight.bold,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !hata,
                    child: TextButton(
                      onPressed: () {
                        //iptal tusuna basildiginda kutunun kapatilmasini sagladik
                        Navigator.pop(context);
                      },
                      child: const BaslikMetni2(
                        metin: "iptal",
                        renk: Colors.tealAccent,
                        fontKalinlik: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      fct();
                      //buton islevini, giris ekranina esitledik
                      //Navigator.of(context).pushNamed(GirisEkrani.routName);
                      Navigator.pop(context);
                      //iptal tusuna basildiginda kutunun kapatilmasini sagladik
                      //Navigator.pop(context);
                    },
                    child: const BaslikMetni2(
                      metin: "Tamam",
                      renk: Colors.red,
                      fontKalinlik: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //kayit ekraninda kullanicidan profil fotografi almak icin kamera, galeri ve kaldir penceresi olusturduk
  static Future<void> resimSecmeDiyalogu({
    //acilir pencerede cikcak ozellikler burada olusturuldu
    required BuildContext context,
    required Function kamera,
    required Function galeri,
    required Function kaldir,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        //uyari kutusu olarak diyalog kutusu dondurduk
        return AlertDialog(
          //uyari ve error ekraninin kenarina radius verdik
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Center(
            child: BaslikMetni(
              metin: "Bir Seçenek Seçiniz Lütfen",
            ),
          ),
          //tasma hatasini engellemek icin kullanildi
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextButton.icon(
                  onPressed: () {
                    kamera();
                    //eger kamera kullanilirsa tekrar kullanilmasi izin verme islemi
                    //kullanildiktan sonra kendisi pencereyi kapatiyor
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.camera, color: Colors.orange),
                  label: const Text("Kamera",
                      style: TextStyle(color: Colors.orange)),
                ),
                TextButton.icon(
                  onPressed: () {
                    galeri();
                    //eger kamera kullanilirsa tekrar kullanilmasi izin verme islemi
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.image, color: Colors.orange),
                  label: const Text("Galeri",
                      style: TextStyle(color: Colors.orange)),
                ),
                TextButton.icon(
                  onPressed: () {
                    kaldir();
                    //eger kamera kullanilirsa tekrar kullanilmasi izin verme islemi
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.red),
                  label: const Text("Resmi Kaldır",
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
