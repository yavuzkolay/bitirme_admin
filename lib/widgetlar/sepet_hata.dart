import 'package:bitirme_admin/widgetlar/baslik_metni.dart';
import 'package:bitirme_admin/widgetlar/baslik_metni2.dart';
import 'package:flutter/material.dart';

class SepetHata extends StatelessWidget {
  const SepetHata({
    super.key,
    required this.resim,
    required this.baslik1,
    required this.baslik2,
    required this.butonMetin,
  });

  final String resim ,baslik1, baslik2, butonMetin;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          Center(
            child: Image.asset(
              resim,
              height: 250,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          BaslikMetni(
            metin: baslik1,
            fontBoyut: 30,
            renk: Colors.deepOrange,
          ),
          const SizedBox(
            height: 10,
          ),
          BaslikMetni2(
            metin: baslik2,
            fontBoyut: 20,
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
            ),
            child: Text(butonMetin),
          ),
        ],
      ),
    );
  }
}