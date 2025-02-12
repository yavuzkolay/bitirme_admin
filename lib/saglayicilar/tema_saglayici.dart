//karanlik ve aydinlik modlar arasi gecis saglaniyor

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

//ChangeNotifier tema degiskikliklerini saglamamiza yariyor
class TemaSaglayici with ChangeNotifier {
  //her yerden erisilmesi icin static yaptik
  static const TEMA_DURUMU = "TEMA_DURUMU";

  //varsayilan karanlik tema
  bool _koyuTema = false;

  bool get koyuTemaAl => _koyuTema;

  //uygulama tekrardan acildiginda koyu ve aydinlik mod hangisinde kaldiysa ordan acilmasini sagliyor
  TemaSaglayici() {
    temaAl();
  }

  //uygulama koyu temadan baslamasini tercih ediyoruz
  koyuTemaAyarla({required bool temaDegeri}) async {
    SharedPreferences tercih = await SharedPreferences.getInstance();
    tercih.setBool(TEMA_DURUMU, temaDegeri);
    _koyuTema = temaDegeri;
    //uygulamada degisiklik oldugunu bildirmek icin bu fonksiyon cagrildi, kullanicinin yaptigi mod degisikligini buraya getirir
    notifyListeners();
  }

  //temayi kullanicidan aldigimiz kisim
  Future<bool> temaAl() async {
    //paylasilan tercih
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //deger null ise dogrudan false olarak ayarlayacak, false oldugu icin varsayilan aydinlik moddur
    _koyuTema = prefs.getBool(TEMA_DURUMU) ?? false;
    //uygulamada degisiklik oldugunu bildirmek icin bu fonksiyon cagrildi
    notifyListeners();
    return _koyuTema;
  }
}
