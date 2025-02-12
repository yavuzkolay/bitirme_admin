import 'package:bitirme_admin/widgetlar/baslik_metni2.dart';
import 'package:flutter/material.dart';

class KontrolPaneliButonlarWidget extends StatelessWidget {
  const KontrolPaneliButonlarWidget(
      {Key? key,
      required this.metin,
      required this.resim,
      required this.tiklanma})
      : super(key: key);

  final String metin, resim;
  final Function tiklanma;

  @override
  Widget build(BuildContext context) {
    //cardlari hareket dedektoru ile sardik ve tiklanma ozelligi ekledik
    return GestureDetector(
      onTap: () {
        tiklanma();
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                resim,
                height: 65,
                width: 65,
              ),
              const SizedBox(
                height: 10,
              ),
              BaslikMetni2(
                metin: metin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
