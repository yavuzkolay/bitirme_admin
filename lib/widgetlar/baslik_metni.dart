import 'package:flutter/cupertino.dart';

class BaslikMetni extends StatelessWidget {
  const BaslikMetni({
    Key? key,
    required this.metin,
    this.fontBoyut = 20,
    this.renk,
    //maxLines(uzunMetin) yapisi, cok uzun metin girilirse bunu alt satira gecmesini engelliyor ve ... olarak belirtiyor
    this.uzunMetin,
  }) : super(key: key);

  final String metin;
  final double fontBoyut;
  final Color? renk;
  final int? uzunMetin;

  @override
  Widget build(BuildContext context) {
    return Text(
      metin,
      maxLines: uzunMetin, //maxLines
      // textAlign: TextAlign.justify,
      style: TextStyle(
        color: renk,
        fontSize: fontBoyut,
        fontWeight: FontWeight.bold,
        //metin tasmasi halinde uc nokta ekler
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
