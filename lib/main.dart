import 'package:bitirme_admin/ekranlar/arama_ekrani.dart';
import 'package:bitirme_admin/widgetlar/tum_siparisler_list.dart';
import 'package:bitirme_admin/ekranlar/kontrol_paneli_ekrani.dart';
import 'package:bitirme_admin/ekranlar/urun_yukleme_formu.dart';
import 'package:bitirme_admin/sabitler/tema_verisi.dart';
import 'package:bitirme_admin/saglayicilar/tema_saglayici.dart';
import 'package:bitirme_admin/saglayicilar/urun_saglayici.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ekranlar/ic_ekran/tum_siparisler/tum_siparisler_ekrani.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: SelectableText(
                    snapshot.error.toString(),
                  ),
                ),
              ),
            );
          }

          //koyu ve acik modun butun uygulamayi etkilemesi icin coklu saglayici MultiProvider kullanildi
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return TemaSaglayici();
              }),
              ChangeNotifierProvider(create: (_) {
                return UrunSaglayici();
              }),
            ],
            child:
                Consumer<TemaSaglayici>(builder: (durum, temaSaglayici, child) {
              return MaterialApp(
                //sag uste bulunan debug yazisini kaldiriyor
                debugShowCheckedModeBanner: false,
                theme: Styles.temaVerisi(
                    koyuTema: temaSaglayici.koyuTemaAl, context: context),
                home: const KontrolPaneliEkran(),
                routes: {
                  //direk erisim olmadigi icin burada ic ekranlari tanimliyoruz
                  TumSiparislerEkrani.routName: (context) =>
                      const TumSiparislerEkrani(),
                  AramaEkrani.routName: (context) => const AramaEkrani(),
                  UrunYuklemeEkrani.routName: (context) =>
                      const UrunYuklemeEkrani(),
                },
              );
            }),
          );
        });
  }
}
