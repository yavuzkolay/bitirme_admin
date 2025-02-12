import 'package:bitirme_admin/modeller/kontrol_paneli_buton_modeli.dart';
import 'package:bitirme_admin/saglayicilar/tema_saglayici.dart';
import 'package:bitirme_admin/widgetlar/baslik_metni.dart';
import 'package:bitirme_admin/widgetlar/kontrol_paneli_butonlar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KontrolPaneliEkran extends StatefulWidget {
  static const routName = '/KontrolPaneliEkran';

  const KontrolPaneliEkran({super.key});

  @override
  State<KontrolPaneliEkran> createState() => KontrolPaneliEkranDurumu();
}

class KontrolPaneliEkranDurumu extends State<KontrolPaneliEkran> {
  @override
  Widget build(BuildContext context) {
    final temaSaglayici = Provider.of<TemaSaglayici>(context);
    return Scaffold(
      appBar: AppBar(
        title: const BaslikMetni(metin: "Kontrol Paneli Ekranı"),
        actions: [
          IconButton(
            onPressed: () {
              temaSaglayici.koyuTemaAyarla(
                  temaDegeri: !temaSaglayici.koyuTemaAl);
            },
            icon: Icon(
                temaSaglayici.koyuTemaAl ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      //izgara halinde gosterim sagladi admin panelde
      body: GridView.count(
        //crossAxisCount, bir satirda kac tane eleman olacagi belirlendi
        crossAxisCount: 2,
        children: List.generate(
          //ekranda kac tane kart olacagini belirledi
          KontrolPaneliButonModeli.kontrolPaneliButonList(context).length,
          (index) => KontrolPaneliButonlarWidget(
            metin: KontrolPaneliButonModeli.kontrolPaneliButonList(context)[index].metin,
            resim: KontrolPaneliButonModeli.kontrolPaneliButonList(context)[index].resim,
            tiklanma:
                KontrolPaneliButonModeli.kontrolPaneliButonList(context)[index].tiklanma,
          ),
        ),
      ),
    );
  }
}
