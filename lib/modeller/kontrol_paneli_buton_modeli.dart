//admin panelde cartlari listeye ekleyerek istedigimiz kadar cart olusturabildik

import 'package:bitirme_admin/ekranlar/urun_yukleme_formu.dart';
import 'package:flutter/material.dart';
import 'package:bitirme_admin/ekranlar/arama_ekrani.dart';
import 'package:bitirme_admin/widgetlar/tum_siparisler_list.dart';

import '../ekranlar/ic_ekran/tum_siparisler/tum_siparisler_ekrani.dart';

class KontrolPaneliButonModeli {
  final String metin, resim;
  final Function tiklanma;

  KontrolPaneliButonModeli({
    required this.metin,
    required this.resim,
    required this.tiklanma,
  });

  static List<KontrolPaneliButonModeli> kontrolPaneliButonList(context) => [
        KontrolPaneliButonModeli(
          metin: "Yeni Ürün Ekle",
          resim: "gorseller/kontrol_paneli/urun_ekle.png",
          tiklanma: () {Navigator.pushNamed(context, UrunYuklemeEkrani.routName);},
        ),
        KontrolPaneliButonModeli(
          metin: "Tüm Ürünleri Görüntüle",
          resim: "gorseller/kontrol_paneli/tum_urunler.png",
          tiklanma: () {
            Navigator.pushNamed(context, AramaEkrani.routName);
          },
        ),
        KontrolPaneliButonModeli(
          metin: "Siparişleri Görüntüle",
          resim: "gorseller/kontrol_paneli/siparisler.png",
          tiklanma: () {
            Navigator.pushNamed(context, TumSiparislerEkrani.routName);
          },
        ),
      ];
}
