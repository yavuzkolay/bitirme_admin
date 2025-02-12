import 'package:flutter/material.dart';

//hic bir metin girilmezse verilmezse varsayilan olarak bu metin yazilacaktir
//required olarak tanimlandigi icin home_screen de bu widget i kullanirken fontSize a deger vermek zorundayiz
//required olursa varsayilan deger veremeyiz, yani required olan deger text widget i nin kullanildigi yerde deger atamasi yapilmali
class BaslikMetni2 extends StatelessWidget {
  const BaslikMetni2(
      {super.key,
        required this.metin,
        this.fontBoyut = 18,
        this.fontStil = FontStyle.normal,
        this.fontKalinlik = FontWeight.normal,
        this.renk,
        this.metinDekorasyon= TextDecoration.none});

  //metin home_screen alaninda metin:"metin" yazilarak istenilen ekrana yazdirilir
  final String metin;

  //fontSize null bir deger alabilecegi icin burada tanimlama yapabiliyoruz
  final double fontBoyut;

  //text widget i nin butun ozelliklerini cagrildigi yerden eklemesi saglandi
  final FontStyle fontStil;
  final FontWeight? fontKalinlik;
  final Color? renk;
  final TextDecoration metinDekorasyon;

  @override
  Widget build(BuildContext context) {
    return Text(
      metin,
      style: TextStyle(
        //text in gozelliklerini burada atama islemi yapmadik, burada text in ozelliklerine degiskenleri atadik
        fontSize: fontBoyut,
        fontWeight: fontKalinlik,
        decoration: metinDekorasyon,
        color: renk,
        fontStyle: fontStil,
      ),
    );
  }
}
