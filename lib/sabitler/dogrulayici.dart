class Dogrulayici {
  static String? urunMetiniYukle({String? deger, String? geriDondurulecekString}) {
    if (deger!.isEmpty) {
      return geriDondurulecekString;
    }
    return null;
  }
}