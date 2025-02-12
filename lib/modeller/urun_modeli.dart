//urunlerin ozelliklerinin tutuldugu sinif olusuturldu

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UrunModeli with ChangeNotifier {
  final String urunId,
      urunBaslik,
      urunFiyat,
      urunKategori,
      urunAciklama,
      urunResim,
      urunMiktar;

  Timestamp? olusturulmaTarihi;

  UrunModeli({
    required this.urunId,
    required this.urunBaslik,
    required this.urunFiyat,
    required this.urunKategori,
    required this.urunAciklama,
    required this.urunResim,
    required this.urunMiktar,
    this.olusturulmaTarihi,
  });

  factory UrunModeli.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    //data.containsKey("")
    return UrunModeli(
      urunId: data["urunId"],//doc.get(field)
      urunBaslik: data["urunBaslik"],
      urunFiyat: data["urunFiyat"],
      urunKategori: data["urunKategori"],
      urunAciklama: data["urunAciklama"],
      urunResim: data["urunResim"],
      urunMiktar: data["urunMiktar"],
      olusturulmaTarihi: data["olusturulmaTarihi"],
    );
  }
}
