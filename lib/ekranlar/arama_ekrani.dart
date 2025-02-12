import 'dart:developer';
import 'package:bitirme_admin/modeller/urun_modeli.dart';
import 'package:bitirme_admin/saglayicilar/urun_saglayici.dart';
import 'package:bitirme_admin/widgetlar/baslik_metni.dart';
import 'package:bitirme_admin/widgetlar/urunler_widget.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AramaEkrani extends StatefulWidget {
  static const routName = "/AramaEkrani";

  const AramaEkrani({Key? key}) : super(key: key);

  @override
  State<AramaEkrani> createState() => _AramaEkraniState();
}

class _AramaEkraniState extends State<AramaEkrani> {
  //arama kutusunda bulunan metnin kontrolunu burada yapiyoruz, (metin duzenleme denetleyicisi)
  late TextEditingController aramaMetniKontrolu;

  @override
  void initState() {
    //arama metni duzenleyicisi, metin duzenleme denetleyicisine atandi
    aramaMetniKontrolu = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    //arama kutusuna yazilan metin is bittiginde hafizadan silinmesi saglandi, (baska ekrana gecersek)
    aramaMetniKontrolu.dispose();
    super.dispose();
  }

  //aranilan urunler listede tutulmaktadir
  List<UrunModeli> urunListeAramasi = [];

  @override
  Widget build(BuildContext context) {
    //urun saglayiciyi burada tanimladik ve bu sayfada kullandik
    final urunSaglayici = Provider.of<UrunSaglayici>(context);

    //kategoriye ayrilan urunleri listelemektedir. urunler kategoriye urun_modeli.dart da ayrildi
    String? gecmisKategori =
        ModalRoute.of(context)!.settings.arguments as String?;
    List<UrunModeli> urunListe = gecmisKategori == null
        ? urunSaglayici.urunler
        : urunSaglayici.kategoriBul(kategoriAdi: gecmisKategori);

    //butun yapiyi GestureDetector hareket dedektoru ile sardik
    return GestureDetector(
      onTap: () {
        //arama kismindan herhangi bir yere basarak cikmayi sagladik
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          //appbarda geri tusu gozukmemesi saglandi
          //automaticallyImplyLeading: false,
          title: BaslikMetni(metin: gecmisKategori ?? "Tüm Ürünler"),
        ),
        body: StreamBuilder<List<UrunModeli>>(
            stream: urunSaglayici.getirUrunAkisi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: SelectableText(
                    snapshot.error.toString(),
                  ),
                );
              } else if (snapshot.data == null) {
                return const Center(
                  child: SelectableText("Henüz Ürün Eklenmedi"),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //TextField(), metin alani tanimlar, metin alani genel yapisini tema_verisi.dart da tanimladim
                    TextField(
                      //x isareti ile metni silmek icin metni kontrol etmemiz gerekir, burada sagliyorum
                      controller: aramaMetniKontrolu,
                      //arama kutusunu dekore ediyorum
                      decoration: InputDecoration(
                        //arama kutusuna silik yazi yazdirdik
                        hintText: "Arama",
                        prefixIcon: const Icon(Icons.search),
                        //GestureDetector ile arama kutusundaki x isaretine yazilan metni silme islevi ekledik
                        suffixIcon: GestureDetector(
                          onTap: () {
                            //setState(() {
                            //x e basildiginda klavyeninde kapatilmasi saglandi
                            FocusScope.of(context).unfocus();
                            aramaMetniKontrolu.clear();
                            //});
                          },
                          child: const Icon(
                            Icons.clear,
                          ),
                        ),
                      ),
                      //arama cubuguna girilen degerleri alir ama yazarken anlik herseyi ceker, olmazasa enter tusuna basinca arama yapar
                      onChanged: (deger) {
                        //kullanici arama yaparken durum degisimi oldugu icin setState kullandim
                        setState(() {
                          //urun aramasini, urun saglayicidan elde ettigimiz degerler ataniyor
                          urunListeAramasi = urunSaglayici.aramaSorgusu(
                              aramaMetni: aramaMetniKontrolu.text,
                              gecmisListe: urunListe);
                        });
                      },
                      //arama cubuguna girilen degerleri kullanicidan aldik
                      onSubmitted: (deger) {
                        //kullanici arama yaparken durum degisimi oldugu icin setState kullandim
                        setState(() {
                          //urun aramasini, urun saglayicidan elde ettigimiz degerler ataniyor
                          urunListeAramasi = urunSaglayici.aramaSorgusu(
                              aramaMetni: aramaMetniKontrolu.text,
                              gecmisListe: urunListe);
                        });
                      },
                    ),

                    //arama kutusu ve urunler arasi bosluk
                    const SizedBox(
                      height: 20,
                    ),

                    //kullanicinin arama yapip yapmadigini kontrol ediyoruz, metin kutusunun bos olup olmaidigi
                    if (aramaMetniKontrolu.text.isNotEmpty &&
                        urunListeAramasi.isEmpty) ...[
                      const Center(
                        child: BaslikMetni(metin: "Ürün Bulunamadı"),
                      ),
                    ],

                    //arama kisminin, urunler kismi
                    //DynamicHeightGridView yapisi ekranda gozukmedigi icin Expanded ile sardik
                    Expanded(
                      child: DynamicHeightGridView(
                        //arama sayfasinda kac oger olacagi belirtildi
                        //itemCount: 200,
                        //arama ekraninda kactane urun olacagini belirdelik. UrunModelleri de bulunan urun sayisi kadar
                        //arama kisminda birsey arandiysa o gosterilir aksi taktirde uygulamada olan urunler gosterilir
                        itemCount: aramaMetniKontrolu.text.isNotEmpty
                            ? urunListeAramasi.length
                            : urunListe.length,
                        //kac tane urun yan yana olacak
                        crossAxisCount: 2,
                        //satirlar arasi bosluk
                        //mainAxisSpacing: 12,
                        //sutunlar arasi bosluk
                        //crossAxisSpacing: 12,
                        builder: (context, index) {
                          //ChangeNotifierProvider ile sardik cunku urun_modelleri.dart ve urun_saglayici.dart etkilesimde degil
                          return UrunWidget(
                            urunId: aramaMetniKontrolu.text.isNotEmpty
                                ? urunListeAramasi[index].urunId
                                : urunListe[index].urunId,
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
