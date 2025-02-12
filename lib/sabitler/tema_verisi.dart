import 'package:bitirme_admin/sabitler/uygulama_renkleri.dart';
import 'package:flutter/material.dart';

class Styles {
  //ThemeData flutterdan geliyor sabittir
  static ThemeData temaVerisi(
      {required bool koyuTema, required BuildContext context}) {
    return ThemeData(
      scaffoldBackgroundColor: koyuTema
          ? UygulamaRenkleri.KoyuScaffoldRenk
          : UygulamaRenkleri.AcikScaffoldRenk,
      cardColor: koyuTema
      //koyuCartrengi eklemedik burada tanimladik
          ? const Color.fromARGB(255, 13, 6, 37)
          : UygulamaRenkleri.AcikCardRenk,
      //koyu modda aydinlik yazilar, aydinlik modda koyu yazilar sagladi
      brightness: koyuTema ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        //appbar da iconlarin rengini tanimladik
        iconTheme: IconThemeData(color: koyuTema ? Colors.white : Colors.black),
        backgroundColor: koyuTema
            ? UygulamaRenkleri.KoyuScaffoldRenk
            : UygulamaRenkleri.AcikScaffoldRenk,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: koyuTema ? Colors.white : Colors.black,
          fontSize: 20,
        ),
      ),

      //arama kisimlari, mail ve sifre gibi metin girilen kisimlar icin olusturuldu
      inputDecorationTheme: InputDecorationTheme(
        //arama kutusunun arka rengini atadik
        filled: true,
        //arama kutusu boyutunu belirledik
        contentPadding: const EdgeInsets.all(10),
        //arama kisminin kenar cizgilerini belli ettik
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,//cizgi genisligini
            color: Colors.transparent, //cizgi rengi
          ),
          borderRadius: BorderRadius.circular(18), //arama kutusu kenar radius
        ),
        //focusedBorder, arama alanina tiklandiginda kenar cizgilerin kaybolmamasi icin
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: koyuTema ? Colors.white : Colors.black,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        //kayit olma ve sifrelerde hatali girislerin olabilecegi durumlarda burasi kullanilacak
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        //hatali giris olmasi halinde buradan belirtecegiz
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}