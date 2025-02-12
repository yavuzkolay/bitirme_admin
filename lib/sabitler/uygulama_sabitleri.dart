import 'package:flutter/material.dart';

class UygulamaSabitleri {
  static const String imageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';

  static List<String> kategoriListesi = [
    'Telefon',
    'Laptop',
    'Elektronik',
    'Saatler',
    'Beyaz Eşya',
    'Moda',
    'Kitaplar',
  ];

  //aclir buton icin kategoriler burada tanimli
  //listeleri acilir listeye donduren widget

  static List<DropdownMenuItem<String>>? get kategoriDropDownListe {
    List<DropdownMenuItem<String>>? menuItem =
        List<DropdownMenuItem<String>>.generate(
      kategoriListesi.length,
      (index) => DropdownMenuItem(
        value: kategoriListesi[index],
        child: Text(kategoriListesi[index]),
      ),
    );
    return menuItem;
  }
}
