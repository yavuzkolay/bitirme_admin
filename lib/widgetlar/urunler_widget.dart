import 'package:bitirme_admin/ekranlar/urun_yukleme_formu.dart';
import 'package:bitirme_admin/saglayicilar/urun_saglayici.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitirme_admin/widgetlar/baslik_metni.dart';
import 'package:bitirme_admin/widgetlar/baslik_metni2.dart';

class UrunWidget extends StatefulWidget {
  const UrunWidget({
    super.key,
    required this.urunId,
  });

  final String urunId;

  @override
  State<UrunWidget> createState() => _UrunWidgetState();
}

class _UrunWidgetState extends State<UrunWidget> {
  @override
  Widget build(BuildContext context) {
    //urun saglayiciyi burada tanimladik ve bu sayfada kullandik
    // final productModelProvider = Provider.of<ProductModel>(context);
    final urunSaglayici = Provider.of<UrunSaglayici>(context);
    final mevcutUrunAl = urunSaglayici.urunIdBul(widget.urunId);

    //resmin boyutunu burada aldik
    Size size = MediaQuery.of(context).size;

    //bos olup olmadigi kontrol edildi
    return mevcutUrunAl == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(0.0),
            //GestureDetector ile urun resimlerine tiklanma ozelligi getirdik
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UrunYuklemeEkrani(
                        urunModeli: mevcutUrunAl,
                      );
                    },
                  ),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: FancyShimmerImage(
                      imageUrl: mevcutUrunAl.urunResim,
                      height: size.height * 0.22,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: BaslikMetni(
                      metin: mevcutUrunAl.urunBaslik,
                      fontBoyut: 18,
                      uzunMetin: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: BaslikMetni2(
                      metin: "${mevcutUrunAl.urunFiyat}\₺",
                      fontKalinlik: FontWeight.w600,
                      renk: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
          );
  }
}
